# I originally pondered if I can find the best choice each minute from only the current numbers,
# thus eliminating the need to search a decision tree of `Θ(4ⁿ)` proportions.
# Like Day 16, I could not find a definitive heuristic formula for a “best-only search”.

class Blueprint
  # matrix: [robotA[costA, costB, …], robotB[…], …]
  attr_reader :matrix, :max_consumption
  def initialize(matrix)
    @matrix = matrix
    @max_consumption = matrix.each_index.map do |i|
      matrix.filter_map { _1[i] }.max
    end
  end
end

class SaveState
  attr_reader :blueprint, :robots, :resources, :time
  protected attr_reader :resources_at
  def initialize(
    blueprint,
    robots    = Array.new(blueprint.matrix.size, 0),
    resources = Array.new(blueprint.matrix.size, 0),
    time = 0
  )
    @blueprint, @resources, @robots, @time = blueprint, resources, robots, time
    @resources_at = Hash.new do|h, t| # Cache pattern
      elapsed_time = t - time
      h[t] =
        resources.zip(robots).map {|res, robot| res + robot * elapsed_time }
    end
  end
  
  # @raise {ZeroDivisionError} if `rate.zero?`
  private def non_neg_ceildiv(required, current, rate) =
    current >= required ? 0 : (required - current).pred / rate + 1
  
  # @return
  #   the time it takes to gather the resources for building the robot of type `i` ASAP
  #   (excluding the 1 {#time}-unit for building it);
  #   returns `nil` if the type has infinite wait time because there’re no suppliers for certain dependency resource(s)
  def build_time(i)
    resources
      .zip(blueprint.matrix[i], robots)
      .filter_map do|res, cost, robot|
        if cost&.positive?
          return nil if robot.zero?
          non_neg_ceildiv(cost, res, robot)
        end
      end.max or 0
  end
  # @return
  #   An array of next states (all new instances), one for each build-worthy robot type;
  #   that is, excluding types with `nil` {#build_time},
  #   types whose current count already matches the {#blueprint}’s {Blueprint#max_consumption},
  #   and (if `block_given?`) types that matches falsely by the given block (via {Array#select!})
  # @param max_time if present:
  #   * also exclude states that exceed this upper time limit
  #   * include at the end a state at `max_time` time reached while building no robots
  #     (unless it matches falsely by the block if given)
  def next_states(max_time: nil, &)
    states2 = robots.each_index.filter_map do |i|
      # We don’t build more robots than the number to match the maximum rate we can consume that resource.
      # (# In fact, we are thrivin’ as soon as we have enough robots to supply for building a geode robot every minute.)
      # This optimization theoretically limits the non-geode decision tree for asymptotic minutes to a constant,
      # though that constant can still go colossal even without factoring the geode robot permutations.
      # We are not tasked for finding the asymptotic yield anyways (thankfully),
      # but this optimization still has a probability to replace the Big-Θ with the Big-O for the short term.
      next if blueprint.max_consumption[i]&.<= robots[i]
      elapsed_time = build_time(i)
      next unless elapsed_time
      elapsed_time += 1 # the 1 `time`-unit for building it
      time2 = time + elapsed_time
      next if max_time&.< time2
      
      # new robot is ready
      robots2 = robots.dup
      robots2[i] += 1
      # build new states
      self.class.new(
        blueprint,
        robots2,
        resources.zip(blueprint.matrix[i], robots).map do|res, cost, robot|
          # spend resources to build new robot
          res -= cost if cost
          # robots collect resources
          res + robot * elapsed_time
        end,
        time2
      )
    end
    states2 << self.class.new(
      blueprint,
      robots,
      resources_at[max_time],
      max_time
    ) if max_time # include a do-nothing state if the target `time` is specified
    states2.select!(&) if block_given?
    states2
  end
  
  # @return states at time `max_time` reached by repeatedly calling {#next_states} (with the given `max_time` and block)
  def states_at(max_time, &)
    bfs = {time => [self]} #=> {t => [states…], …}
    (time...max_time).each do|t|
      states_this_time = bfs.delete(t)
      next unless states_this_time
      states2 = states_this_time.flat_map { _1.next_states(max_time:, &) }
      bfs.merge!(states2.group_by(&:time)) { _2 + _3 }
      warn(
        "T #{t}\t#{states_this_time.size}"\
        " -> #{states2.size}"\
        " => #{bfs.each_value.sum(&:size)} states"
      ) if $DEBUG
    end
    bfs[max_time]
  end
end

# `[ore, cly, obs, geo]`
class Day19Blueprint < Blueprint
  attr_reader :id
  # @param string 
  #   Blueprint [0]:
  #     Each ore robot costs [1] ore.
  #     Each clay robot costs [2] ore.
  #     Each obsidian robot costs [3] ore and [4] clay.
  #     Each geode robot costs [5] ore and [6] obsidian.
  def initialize(string)
    id, ore_ore, cly_ore, obs_ore, obs_cly, geo_ore, geo_obs =
      string.scan(/\d++/).map(&:to_i)
    @id = id
    super(
      [
        [ore_ore,       0,       0],
        [cly_ore,       0,       0],
        [obs_ore, obs_cly,       0],
        [geo_ore,       0, geo_obs]
      ]
    )
  end
end

class Day19SaveState < SaveState
  def initialize(
    blueprint,
    robots    = [1, 0, 0, 0],
    resources = [0, 0, 0, 0],
    minute = 0
  ) = super
  def geodes = resources.fetch(3)
  
  # Override with a slightly-faster version that utilizes the light-weight design of {Day19Blueprint}s
  def build_time(i)
    recipe = blueprint.matrix[i]
    wait_time2 = if i > 1
      i2 = i.pred
      robot2 = robots[i2]
      return nil if robot2.zero?
      non_neg_ceildiv(recipe[i2], resources[i2], robot2)
    end
    wait_time = non_neg_ceildiv(recipe.first, resources.first, robots.first)
    (wait_time2&.> wait_time) ? wait_time2 : wait_time
  end
  
  # Similar to {#states_at}`(max_time).map(&:geodes).max`, but uses a block that
  # * reduces memory usage by cleaning up the mountain of `max_time` states after extracting their {#geodes} counts,
  #   which is the only info this method and the AoC puzzle are interested in
  # * discards states whom not even their overëstimates (see implementation) could meet the currently-known maximum
  #   (mainly as an criterion for eliminating late-game states that still have 0 geode robots –
  #    some people mitigate this issue by only building geode robots whenever available)
  def max_geodes_at(max_time)
    max_geodes = geodes
    states_at(max_time) do|state2|
      if state2.time == max_time
        geodes2 = state2.geodes
        if geodes2 > max_geodes
          max_geodes = geodes2
          warn "max =\t#{max_geodes} open geodes" if $DEBUG
        end
        next false
      end
      # Overëstimation: calculate the geodes this `state2` can crack if it
      # * does not consume (although still requires) ore to build obsidian and geode robots
      # * can use resources produced in the future (up ’til `max_time`) to build robots
      # * can build all robot types at the same `time`
      # * build the aforementioned robots – excluding ore robots – starting from this minute
      elapsed_time = max_time - state2.time
      i = 0
      ore = state2.resources_at[max_time][0]
      state2.resources_at[max_time].reduce do |est_res, res2|
        i2 = i.succ
        est_robot2 = [
          est_res / blueprint.matrix[i2][i],
              ore / blueprint.matrix[i2][0],
          elapsed_time
        ].min
        i = i2
        # aₙ = a + (n - 1)d = elapsed_time - 1; n = est_robot2; d = 1
        # Sₙ = n ÷ 2 × (a + aₙ)
        #    = (aₙ - (n – 1)d + aₙ) × n ÷ 2
        #    = (2aₙ + (1 - n)) × n / 2
        #    = (2 × (elapsed_time - 1) + 1 - n) × n / 2
        #    = elapsed_time × 2 - 2 + 1 - est_robot2)) × est_robot2 / 2
        (2 * elapsed_time - est_robot2).pred * est_robot2 / 2 + res2
      end > max_geodes
    end
    max_geodes
  end
end

puts(
  'Part 1', 
  File.foreach('input.txt').filter_map do|line|
    blueprint = Day19Blueprint.new(line)
    Day19SaveState.new(blueprint).max_geodes_at(24) * blueprint.id
  end.sum
) if false # Part 1
puts(
  'Part 2', 
  File.foreach('input.txt').take(3).filter_map do|line|
    Day19SaveState.new(Day19Blueprint.new(line)).max_geodes_at(32)
  end.inject(:*)
) if true # Part 2

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
  attr_accessor :blueprint
  attr_reader :robots, :resources, :time
  def initialize(
    blueprint,
    robots    = Array.new(blueprint.matrix.size, 0),
    resources = Array.new(blueprint.matrix.size, 0),
    time = 0
  )
    @blueprint, @resources, @robots, @time = blueprint, resources, robots, time
  end
  
  # @raise {ZeroDivisionError} if `rate.zero?`
  def self.non_neg_ceildiv(required, current, rate) =
    (current >= required) ? 0 : (required - current).ceildiv(rate)
  # @return
  #   the time it takes to gather the resources for building the robot of type `index` ASAP
  #   (excluding the 1 `time`-unit for building it);
  #   returns `nil` if the type has infinite wait time because there’re no suppliers for certain dependency resource(s)
  def build_time(index)
    resources
      .zip(blueprint.matrix[index], robots)
      .filter_map do|res, cost, robot|
        if cost&.positive?
          return nil if robot.zero?
          self.class.non_neg_ceildiv(cost, res, robot)
        end
      end.max or 0
  end
  # @return
  #   An array of next states (all new instances), one for each buildable robot type
  #   (that is, excluding types with non-`nil` {#build_time} and/or by optimization(s))
  # @param max_time if present:
  #   * exclude states that exceed this upper time limit
  #   * include a state at `max_time` time reached while building no robots
  def next_states(max_time: nil)
    states2 = robots.each_index.filter_map do |index|
      # We don’t build more robots than the number to match the maximum rate we can consume that resource.
      # (# In fact, we are thrivin’ as soon as we have enough robots to supply for building a geode robot every minute.)
      # This optimization theoretically limits the non-geode decision tree for asymptotic minutes to a constant,
      # though that constant can still go colossal even without factoring the geode robot permutations.
      # We are not tasked for finding the asymptotic yield anyways (thankfully),
      # but this optimization still has a probability to replace the Big-Θ with the Big-O for the short term.
      next if blueprint.max_consumption[index]&.<= robots[index]
      elapsed_time = build_time(index)
      next unless elapsed_time
      elapsed_time += 1 # the 1 `time`-unit for building it
      time2 = time + elapsed_time
      next if max_time&.< time2
      
      # new robot is ready
      robots2 = robots.dup
      robots2[index] += 1
      # build new states
      self.class.new(
        blueprint,
        robots2,
        resources.zip(blueprint.matrix[index], robots).map do|res, cost, robot|
          # spend resources to build new robot
          res -= cost if cost
          # robots collect resources
          res + robot * elapsed_time
        end,
        time2
      )
    end
    
    if max_time
      # include a do-nothing state
      elapsed_time = max_time - time
      states2 << self.class.new(
        blueprint,
        robots,
        resources.zip(robots).map {|res, robot| res + robot * elapsed_time },
          # robots collect resources
        max_time
      )
    end
    states2
  end
  
  # @return states at time `max_time` that are reached by enumerating though {next_states}.
  # @param optimize (TODO)
  #   if `true`, eliminate states whose yield at time `time` is  another state with the same {robots} count;
  #   if `false`, includes all states regardless of their profits **(warning: expect `Θ(kⁿ)`)**
  def states_at(max_time, optimize: true)
    bfs = {time => [self]} #=> {t => [states…], …}
    (time...max_time).each do|t|
      states_this_time = bfs.delete(t)
      next unless states_this_time
      bfs.merge!(
        states_this_time.flat_map { _1.next_states(max_time:) }.group_by(&:time)
      ) { _2 + _3 }
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
  def quality_level = geodes * blueprint.id
  
  # Override with a slightly-faster version that utilizes the light-weight design of {Day19Blueprint}s
  def build_time(index)
    recipe = blueprint.matrix[index]
    wait_time2 = if index > 1
      index2 = index.pred
      robot2 = robots[index2]
      return nil if robot2.zero?
      self.class.non_neg_ceildiv(recipe[index2], resources[index2], robot2)
    end
    # noinspection all (suppress nilability of the `.first` calls)
    wait_time =
      self.class.non_neg_ceildiv(recipe.first, resources.first, robots.first)
    (wait_time2&.> wait_time) ? wait_time2 : wait_time
  end
end

puts(
  'Part 1', 
  File.foreach('input.txt').filter_map do|line|
    Day19SaveState.new(Day19Blueprint.new(line)).states_at(24).max_by(&:geodes)
  end.sum(&:quality_level)
)

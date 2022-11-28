# `template-ruby-gem`

Built upon [`ParadoxV5/mygem`](https://github.com/ParadoxV5/mygem),
this is a mediocre yet thorough template for a Ruby Gem project.
Note: only `gem`, no `rake`.


## How to Setup

* Rename all occurrences of `mygem`, lower- or title-case, with the name of your epic Gem.
  * [`lib/mygem/`](lib/mygem)
  * [`lib/mygem/version.rb Line 3`](lib/mygem/version.rb#L3)
  * [`lib/mygem.rb` and Line 1](lib/mygem.rb#L1)
  * [`sig/mygem.rbs` and Line 1](sig/mygem.rbs#L1)
  * [`mygem.gemspec` and Lines 2, 5, 7, 13 & 19](mygem.gemspec#L2-L19)
  * [`.github/workflows/packages.yml` Line 22](.github/workflows/packages.yml#L24)
* Replace all occurrences of `AUTHOR` with the name of you, the author of your Gem.
  * [`mygem.gemspec` and Lines 10, 13 & 19](mygem.gemspec#L10-L19)
  * [`.github/workflows/packages.yml` Line 22](.github/workflows/packages.yml#L24)
* Update the [`gemspec`](mygem.gemspec) with your Gem’s information. (See [§`*.gemspec`](#gemspec))
* Overwrite this `README` with an introduction to your epic project.
* Replace *this template’s* [`LICENSE.txt`](LICENSE.txt) with
  [one](https://choosealicense.com/) that engraves your honor for posterity.


## What’s Inside

Follow [the convention](https://guides.rubygems.org/patterns/#file-names) regarding the file structure:

###### [`lib/**`](lib/)
This is the folder where people put their Gem sources.

###### [`sig/**`](sig/)
Have you heard of [RBS](https://github.com/ruby/rbs)?
Yep, Ruby 3 introduced this official static type checking system.
The convention is to put your RBS signatures in this folder.

###### [`*.gemspec`](mygem.gemspec)
The `gemspec` is [the metadata file](https://guides.rubygems.org/specification-reference/) for your epic Gem.
Any file name is technically acceptable, but a `.gemspec` suffix is the convention.
I have also prepared developer, license and URL information lines in the metadata,
though you can remove any bells and whistles that don’t apply to your project.

###### [`Gemfile`](Gemfile)
[The `Gemfile`](https://bundler.io/guides/gemfile.html) is the **Bundler** project file where
you *would* declare dependencies **if only using Bundler** (i.e., not cutting a Gem).
For Gems, the [`gemspec`](#gemspec) already covers this role in its metadata.
This redundancy leaves `Gemfile` the job of specifying Gem *sources*, e.g., if your Gem depends on a
[GitHub Packages Gem](https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-rubygems-registry#installing-a-package).

> There was a discussion before about whether the `Gemfile` makes `.gemspec`’s
> [`add_development_dependency`](https://guides.rubygems.org/specification-reference/#add_development_dependency)
> obsolete: rubygems/rubygems#1104
> 
> Overall, I took their conclusion as – Bundler (`Gemfile`) and RubyGem (`.gemspec`) are two separate utilities;
> it’s just good Rubyists like us that use them together.

###### [`LICENSE.txt`](LICENSE.txt)
See [§License](#License)

###### [`README.md`](README.md)
You are reading this right now…

###### [`.github/workflows/*`](.github/workflows)
Inside this folder are thoroughly configured ([minimal modification](#How to Setup) required)
[GitHub Actions](https://github.com/features/actions) scripts that enable basic continuous deployment:

* [`packages.yml`](.github/workflows/packages.yml) –
  [Publish to GitHub Packages](https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-rubygems-registry)
  after a GitHub Release is published.
* [`pages.yml`](.github/workflows/pages.yml) – Generate  [YARD docs](https://yardoc.org/) and
  [publish to GitHub Pages](https://github.blog/changelog/2022-07-27-github-pages-custom-github-actions-workflows-beta/)
  after the `main` branch receives a code update in the Ruby sources folder [`lib`](lib).

###### [`.yardopts`](.yardopts)
[The `.yardopts` file ](https://rubydoc.info/gems/yard/file/docs/GettingStarted.md#yardopts-options-file)
records the default command-line parameters, so you only need to execute `yard doc`.

* `--markup markdown` – ~~Who doesn’t use Markdown?~~
* `--markup-provider commonmarker` – Use [the CommonMarker Gem](https://github.com/gjtorikian/commonmarker)
  instead of *whatever impaired default it happens to be out-of-the-box* (mine was `RDoc::Markdown`).

###### [`.gitignore`](.gitignore)
[The `.gitignore` file](https://git-scm.com/docs/gitignore) lists file patterns to exclude from Git’s records.

* Including `Gemfile.lock`/`rbs_collection.lock.yaml` with the repo guarantees others’ checkouts use your identical functioning dependency versions;
  omitting it encourages using dependencies’ latest versions at the risk of incompatible updates.
* Don’t include IDE (e.g., [RubyMine](https://www.jetbrains.com/ruby/)) configurations
  unless you want to enforce your organization’s digital environment.


## License

I have determined that this template is all traditional knowledge and no copyrightable production.
Therefore, I am licensing this template under the infamous [WTFPL](http://www.wtfpl.net/).

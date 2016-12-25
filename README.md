# Topicz

Topicz is a simple topic repository administration tool, where the repository is a regular filesystem.

## Installation

Install it as:

    $ gem install topicz

See below (*Development*) in case you’re working with a Git clone directly.

## Usage

    $ topicz —help
    Usage: topicz [options] <command> [options]
        -c, --config FILE  Uses FILE as the configuration file

    Where <command> is one of:

      init   : Initializes a new topic repository
      create : Creates a new topic
      list   : List topics
      path   : Prints the full path to a topic
      journal: Opens a (new) weekly journal entry for a topic
      note   : Opens a new note for a topic
      stats  : Generates weekly statistics across all topics
      report : Generates a weekly report of all topics
      alfred : Searches in Alfred Script Filter format
      help   : Shows help about a command

## Background

In my daily work I have to deal with a lot of different topics. New topics pop up often and existing topics are in varying degree of completeness. Sometimes nothing happens to a topic for weeks. Sometimes topics are short-lived, sometimes they stick around for years. All in all, keeping track of all the topics I work on is a big challenge for me.

The way my mind works: if I can’t find a structure to organize my work in, I feel stressed. But like everybody else I prefer to be relaxed. Also I don’t like proprietary formats or tools that force me in a specific way of working.

So I created my own structure, completely filesystem based, and scripts on top of it to integrate it with the other tools I use on my Mac, like [Alfred](http://www.alfredapp.com). Topicz collects all those scripts into a consistent, single command-line interface that I can easily change and extend whenever I need.

## The topic repository

A topic repository is nothing more than a directory on disk. This directory has subdirectories, one for each topic. The name of the subdirectory is what you like it to be. A topic, in turn, holds a number of directories. Here’s a basic layout:

    . (topic root)
    ├── Topic 1
    │   ├── topic.yaml
    │   ├── Documents
    │   ├── Journal
    │   ├── Logs
    │   └── Reference Material
    ├── Topic 2
    ├── Topic …
    └── Topic n

The `topic.yaml` file is entirely optional. More information on that later.

A topic can certainly have other subdirectories than the ones shown above. These four are the ones I always use. Where needed I add more. For example when I go to a conference, I typically add the directories `Travel` and `Bills`.

### Documents and Reference Material

The `Documents` and `Reference Material` directories speak for themselves. The first is for stuff I create, the second for stuff that others create. Files and subdirectories in these directories must have filenames that are prefixed with the date in `YYYY-mm-DD`. That keeps the files in the right order, and it makes the files show up in the `stats` command.

### Journal

The `Journal` directory is more interesting. It contains Markdown files only, and each filename follows the pattern `<year>-week-<week>.md`. If there was some kind of progress on a topic in a certain week, I describe it here. Every week I send a progress report to my colleagues about all the topics I worked on. Topicz’s `report` command creates this report for me automatically from the separate journal entries. And of course Topicz also helps me creating and opening the right journal files, depending on the topic I work on.

### Notes

The `Notes` directory is for meeting notes, scratchpads, reminders, whatever. Every note is a Markdown file and each filename follows the pattern `<YYYY-mm-DD> <subject>.md`. Again Topicz helps me to quickly create and open notes for the topic I’m working on.

## Repository configuration

Topicz needs to know just one thing: where your repository is. You stick this into a configuration file, and tell Topicz about this file using the `-c` flag. If you have one topic repository, you can also store this file as `~/.topiczrc`. Then you don’t need to specify it when using the CLI.

The first time you use Topicz, just do this:

    $ topicz init /path/to/my/topic/repository

Topicz will do two things. First it will create an empty directory at the location you specified. Secondly it will write this location into `~/.topiczrc`.

Some commands call an external text editor, for example to edit journals and notes. By default Topicz will use the `EDITOR` environment variable. You can override it on a per-repository basis by defining an `editor` property in the configuration file.

Maybe you put some directories in the repositories that you want Topicz to ignore. No problem: define a property `excludes`, with either a single value or an array of values. Each value must be a regular expression. For example, I use `^_` to skip all directories that start with an underscore.

## Topic configuration

Each topic directory can have a `topic.yaml` file in it, which holds a YAML file describing that topic. It looks as follows:

    title: <topic title>
    id: <topic ID>

If the YAML file is missing, or a field in the file is missing, then Topicz falls back on sensible defaults: the title is set to the name of the topic directory, and the ID is generated from this name by lowercasing it, replacing whitespace with hyphens, and removing strange characters.

> This file is where I’m planning to add lots of functionality to. For example to store topic relationships, or to store metadata. See *Plans* below.

You’re free to edit this file at any time, although Topicz also provides commands to help you do this. You never actually need to edit these YAML files themselves, if you don’t want to.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Plans

* Allow topics to be archived and unarchived when no longer relevant.
* Allow relationships between topics to be defined in the YAML files, and use these to generate graphs for Graphviz: `depends-on`, `part-of`, `relates-to`. The CLI will help to guarantee correctness, for example when archiving a topic, or when renaming one’s title and/or ID.
* Allow metadata to be defined for each topic, like main stakeholders, categories and topic goals.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/voostindie/topicz.


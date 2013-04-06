# pe_280_mcollective_fix

[280_hotfixes]: https://puppetlabs.com/puppet-enterprise-hotfixes-2-8-0/
[add_class]: http://docs.puppetlabs.com/pe/2.8/console_classes_groups.html#adding-a-new-class
[assign_class]: http://docs.puppetlabs.com/pe/2.8/console_classes_groups.html#grouping-nodes

#### Table of Contents

1. [Overview - What is the pe_280_mcollective_fix module?](#overview)

2. [Description](#module-description)

3. [Setup (requirements and affected subsystems)](#setup)

4. [Usage](#usage)

5. [Reference (available classes)](#reference)

6. [Limitations/compatibility](#limitations)

## Overview

This module is an easier way to install the hotfix packages for Puppet Enterprise 2.8.0's stomp gem bug. It's only necessary if you're running PE 2.8.0; all later versions are exempt, and this module will have no effect on them.

## Module Description

PE 2.8.0 was released with a bug that prevents live management and MCollective filters from functioning. [See here for more info, as well as links to the individual packages.][280_hotfixes]

This hotfix module is a convenience front-end for installing those hotfix packages. It will fully resolve the problem on affected systems, and lets you fix all of your affected systems with one step.

Again, this is **only necessary with PE 2.8.0** -- releases from 2.8.1 onward will not have this issue and require no additional action.

## Setup

### What `pe_280_mcollective_fix` affects

On *nix systems running PE 2.8.0, this module will copy a package file to `/tmp`, install that package, and, if necessary, restart the `pe-mcollective` service.

Once the system is upgraded to PE 2.8.1, the module will cease to manage any state on the system. Most systems and site policies will eventually delete the package file from `/tmp`. If it is never removed, the maximum impact is negligible: approximately 150KB of wasted disk space.

### Setup Requirements

This module requires puppetlabs/stdlib on the puppet master, which is installed by default on PE.

It expects that affected nodes are running the `pe-mcollective` service, which is enabled by the `pe_mcollective` module in the console's "default" group.


## Usage

### Normal Usage

Assign the class `pe_280_mcollective_fix` to every node in your infrastructure. It will either fix the PE 2.8.0 MCollective problems or have no effect, depending on whether the node is affected by the problem.

The easiest way to do this in PE is to:

* [Add the class to the Puppet Enterprise console][add_class]
* [Assign the class to the console's "default" group][assign_class]
* Wait approximately 30 minutes (or whatever your site's node checkin interval is)

After every node has checked in, the bug will be fully resolved, and live management and MCollective features will resume normal operation.

Once you have upgraded to a later version of PE and have no remaining PE 2.8.0 nodes, you may remove the class from the console and uninstall the module with `puppet module uninstall pe_280_mcollective_fix`.

### One-Off Usage

You may alternately use the `puppet apply` tool to immediately apply the `pe_280_mcollective_fix::apply` class to a single node. (This wrapper class is needed in order to properly restart the `pe-mcollective` service.)

## Reference

### Class `pe_280_mcollective_fix`

The main class. Assign this to nodes from a puppet master.

### Class `pe_280_mcollective_fix::apply`

A wrapper class for use with `puppet apply`.

## Limitations

On Windows nodes and non-PE-2.8.0 nodes, this module will have no effect. It will not cause any adverse effects on these nodes.


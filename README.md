<!--
{
    "prerequisites": [
        "git/remotes"
    ]
}
-->
# Source Code Management (SCM) 
<!--TOC_START-->
### Contents
- [Overview](#overview)
- [Repositories](#repositories)
	- [Multiple Repositories](#multiple-repositories)
	- [Branches to Build](#branches-to-build)
- [Triggering Builds from SCM Changes](#triggering-builds-from-scm-changes)
	- [Poll SCM](#poll-scm)
		- [CRON](#cron)
	- [Web Hooks](#web-hooks)
- [Demo](#demo)
	- [Setup Git Repositories](#setup-git-repositories)
	- [Upload the Provided Code](#upload-the-provided-code)
	- [Webhook Configuration](#webhook-configuration)
	- [Push a New Change](#push-a-new-change)

<!--TOC_END-->
## Overview
Source Code Management, also reffered to as Version Control, Source Control Management, SCM, or by simply refferring to a tool such as Git, plays an important role in automating project builds and deployments with Jenkins.

The most common way of using SCM in one of your jobs is by utilising the suggested GitHub plugin for Jenkins.

## Repositories
Here we can see a very simple configuration for SCM in a project.
This example will download the `master` branch from this repostory in the projects workspace:

![Jenkins SCM Configuration](https://lh3.googleusercontent.com/vy3PzZydHTEF7g1oH7J4gEURjTVcKoJVyX01E6AFqAvFAboUEMx3Uz5YK7ZwDwV4-I8EFcpad9ajdGW9ULsaYqNJZ2Wg5aonqu210kabj04GVkcOtbCDTprsDEbFLuvnnoqI-Hn75HrLgudXSG5-Og09492SI_tOxGVeGepfG2ahrQEBZViM5RAMFiu5p73tkcKAVX7nJVcyuSR8hJ4vNT1Al39j-FZ3UeUJV6t2VSC_JRGyq3_-Xn0ikgM2WXp4XJJun7No9T-ebGug1rEjlqApdy-NADc03tJQ7IHKMPG8-D6ysb_R-0AfmRTjbwv_JGqN6ylzfwP5p2EQuKYfPAYn-Uq-_Ybsnfalar2Y9X6YIz7qEjZTfw05oSZCmNw5oAKHdldzsfdRVzIq81dNsgbMPKqs7eydnJOxRprqVIPm5rIgQg2BVd8XE8LsdqeD_PqcJFx64-Vj1FUEkfeiTVMnh--WQfwjpm9Q00o7HALGVbLrGI-Iuj5L7LF-kdSeyL0HXLs3_sqBHiPp8gdb9kG9ERenP5XaAkckY62_NDhkQctAYOEWdF6QkiN431byRPUoAJvGJ0k9jpxnAIDDDaABPv4YrnXZQHsv1PR41blsWioYYgetl0r-FCnFycKEUBNwWVQ3oMpZRfXPPVeMzDcNFZrX2MyKeutS0OQ9ZNqoKUZke7h6B7IdelVHJSiuIJkh3Fa_OInkJ9Jjot7h5UcpohATWJzrsa_T6pUtLbdkGnRm=w1174-h696-no)

### Multiple Repositories
You may have noticed the `Add Repository` button which will allow us to download more than one repository at a time.

These are all downloaded into the same workspace but with different remotes setup for Git.
The last repository specified will be the one that is checked out to in the project workspace.

The first repository will have a remote set as `origin`, then for every respository added, a number will be appended.

For example, if you had 3 repositories being downloaded, the remotes would be named `origin`, `origin1`, `origin2`.

This default behaviour isn't ideal, so it's recommended that you configure the name of the remotes yourself under the `Advanced...` option and in the `Name` field for each repository that you add.

### Branches to Build 
After specifying which repositories that you want to fetch, you can also choose which branches that you would like to build.
There are some quite complex different ways of checking out code that you can do here but usually being simple is better; there isn't a great deal of reasons to use anything other than the default value here (`*/master`) on simple projects.

If you would like to be able to build different branches easily then you could use a string parameter by entering something like `*/${BRANCH}` into the `Branch Specifier` field.

## Triggering Builds from SCM Changes
Jenkins jobs can be automatically triggered by changes in SCM.
When some changes have been push to a repositorym, the job can be triggered automatically by this.

There are two main ways to trigger builds in this way, depending on your situation:
- Poll SCM:
    This method is preferred if your instance of Jenkins is **not** accessible from the internet.
- Web Hooks (Preferred)
    Web Hooks are the preferred way of triggering build automatically from SCM if your instance of Jenkins can be accessed from the internet.

### Poll SCM
Poll SCM works by checking for changes on a schedule.
For the given schedule, Jenkins will make a request to your Git respository to check if there has been any changes.

This can be configured by selecting `Poll SCM` in the `Build Triggers` section.
A `Schedule` text box will then appear for you to configure the schedule.

#### CRON
The format for configuring the schedule is cron time format.
If you haven't heard of this before you can head over to [crontab guru](https://crontab.guru/#*_*_*_*_*); this site will give you a change to play around with different schedules quite easily.

The shortest time schedule that you can have is "every minute", which can be configured by entering `* * * * *` into the `Schedule` field.

### Web Hooks
As discussed before, this is the preferred method if your instance of Jenkins can be accessed from the internet.
This is because instead of constantly checking for new changes, the job can be triggered but a Webhook which is really just a HTTP POST request to the jenkins server.

These Web Hooks can be configured on websites like GitHub, Bitbucket and GitLab to send a HTTP POST request to `/github-webhook/` on your Jenkins server.

This POST request will contain either a JSON or XML payload with information about which repository and branch has been updated.
Jenkins can then use this information automatically build the correct job.

To configure Web Hooks to work you will need to check the `GitHub hook trigger for GITScm polling` option under the `Build Triggers` section on your Jenkins job that you are wanting to automatically trigger.
You will then need to configure your Git service provider (such as GitHub) to send Webhooks to `[JENKINS_ADDRESS]/github-webhook/`.

## Demo
In this demo we'll be automating the deployment of a simple website.
There are two main components to this application:
- Frontend
    A HTML and JavaScript website that makes calls to the Backend service.
    This website is hosted with NGINX as a webserver
- Backend
    A NodeJS server which can send JSON data over HTTP.

### Setup Git Repositories
For this example we are going to need couple of Git repositories.
Go ahead and create two repositories on GitHub called the following:
- `jenkins-scm-frontend`
- `jenkins-scm-backend`

### Upload the Provided Code
In this module there are 2 folders for you to download and then upload the contents to the two repositories that you created beforehand.

### Webhook Configuration
To configure Web Hooks to work you will need to check the `GitHub hook trigger for GITScm polling` option under the `Build Triggers` section on your Jenkins job that you are wanting to automatically trigger.

Next, you need to setup the Webhook on a Git service provider like GitHub etc.
For this example we will be discussing how you can use GitHub to send Web Hooks to your instance of Jenkins:
1. On your GitHub project navigate to the `Settings` tab.
2. Click on `Webhooks`
3. Set the `Payload URL` to be `[JENKINS_ADDRESS]/github-webhook/`; **Don't miss the trailing `/` on the end of the Payload URL!**
4. Set the `Content type` to be `application/json`
5. Select `Add Webhook`

### Push a New Change
Now try pushing a change to your GitHub repository, your Jenkins job should start building very shortly afterwards.

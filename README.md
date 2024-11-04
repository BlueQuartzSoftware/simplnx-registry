# simplnx vcpkg registry #

This is the vcpkg registry for [simplnx](https://github.com/BlueQuartzSoftware/simplnx).

[https://devblogs.microsoft.com/cppblog/registries-bring-your-own-libraries-to-vcpkg/](https://devblogs.microsoft.com/cppblog/registries-bring-your-own-libraries-to-vcpkg/)

## So you wanna update the version of a Library ##

### Do the GitHub Release and Compute the SHA512 Hash ###

First create a release for the given tag up on GitHub. Let's use EbsdLib as an example. Go to [https://www.github.com/bluequartzsoftware/EbsdLib](https://www.github.com/bluequartzsoftware/EbsdLib) and create a release with the given tag. 

+ Put in the release notes into the comments section.
+ Use the `vX.Y.Z` versioning scheme.
+ Publish the release.
+ Download the .tar.gz source archive that was created.
+ Compute the SHA512 hash for the source file.
  + `shasum -a512 EbsdLib-1.0.33.tar.gz`

The output should be something like:

    656cf17ed93bd4d03631809891a3c1b53f73924956d5f36b9b0d5678cd27968c8e9487da70e45ec4641a7789cfcd55e11d873fe6f0c65d0df720b6d5e532f52a  EbsdLib-1.0.33.tar.gz

### Update simplnx-registry ###

+ git clone ssh://git@github.com/bluequartzsoftware/simplnx-registry
+ OR git pull --rebase origin master

There are a number of files that you need to update plus some `git` shenanigans to get everything correct. You will also need to update a pair of files in `simplnx` and then push and put in a PR for those changes.

### Update the simplnx-registry/ports/XXXX/Portfile.cmake ###

Edit the file `simplnx-registry/ports/ebsdlib/portfile.cmake` to update the section `vcpkg_from_github()` to update the `SHA512` arguments.

    SHA512 e477a8cca267d51c486e9cf21915ca7efbe0c9c0c1693b857399c4c4383d4721cb3c87ed6d82a3eccf97585aac199aa51dc8df0e74bdd5a8774a40740ea2b485

Save the file.

### Update the simplnx-registry/ports/XXXX/vcpkg.json File ###

Edit the file `simplnx-registry/ports/XXXXX/vcpkg.json` file. You need to update the `version` string to match the version of the library. Note to **leave out the 'v'** from the version. The json is below for our v1.0.13 library.

    "version": "1.0.13",
    "port-version": 0,

If the actual version of the library is being updated, for example from 1.0.26 to 1.0.33, then the "port-version" should be reset to 0 and this all you have to do.

If you are updating just the "portfile.cmake" but the actual version of the library stays the same then you need to increment the "port-version" by 1 and then edit the *simplnx-registry/versions/e-/ebsdlib.json* file to have something like the following:

        {
        "versions": [
            {
            "version": "1.0.8",
            "port-version": 0,
            "git-tree": "0a1311ed57d46398b30528a99c77abbd6a3c274d"
            },
            {
            "version": "1.0.8",
            "port-version": 1,
            "git-tree": "7759d808b49b29f1908b56265ff41e2290607859"
            },
            {
            "version": "1.0.14",
            "port-version": 0,
            "git-tree": "879be173508008c247ec9117a612ce370260b680"
            }
        ]
        }

Which says there are 2 different vcpkg versions of the EbsdLib 1.0.8 library and there is a single vcpkg version of EbsdLib 1.0.14

Save the file vcpkg.json file, (and possibly the ebsdlib.json file)

### Update the port version File ###

Edit `simplnx-registry/versions/e-/ebsdlib.json` file to update the `version` json entry to match the same string that you just updated in the `simplnx-registry/ports/ebsdlib/vcpkg.json` file. For example here is the new section for v1.0.33 of EbsdLib.

```
    {
      "version": "1.0.33",
      "port-version": 0,
      "git-tree": "REPLACE ME"
    }
```

Save the file.

### Update the baseline.json file ###

Update the file `simplnx-registry/versions/baseline.json` file.

+ Update the `baseline` json key and set it's value to the version of the library that is needed. In the case of our example EbsdLib update we end up with a section like the following:

    "ebsdlib": {
      "baseline": "1.0.33",
      "port-version": 0
    },

Save the file.

### Use Git Commit a few times ###

Now we are going to commit what we have so far.

    [user]$ git add .
    [user]$ git commit -s -a -m "[ebsdlib] Update to version 1.0.33"

Now you need to find the exact git object so that you can update the `simplnx-registry/versions/e-/ebsdlib.json` file AGAIN. (Yes, we are editing it a second time.)

    [user]$ git rev-parse HEAD:ports/ebsdlib

That should create a single hash that looks something like `879be173508008c247ec9117a612ce370260b680`. (It will be different each time we go through this). Now take the `879be173508008c247ec9117a612ce370260b680` string and paste it into the value for `git-tree` json key in the file `simplnx-registry/versions/e-/ebsdlib.json`. Save the file. Now commit that change using this git command:

    [user]$ git add .
    [user]$ git commit --amend --no-edit

and finally push that change to the `simplnx-registry` repository. **NOTE** the git hash of the commit. You can get the hash by using `git log` to look (or SourceTree).

## Update `simplnx` Library ##

* Git Branch simplnx
* Edit the file `simplnx/vcpkg-configuration.json` and find the `baseline` key and replace the value with the git hash from the `simplnx-registry` commit.
* Save the file.
* Try doing a completely clean build of `simplnx` to test out the new `simplnx-registry` changes.
* Assuming everything works, commit and push the branch.
* go to [https://www.github.com/bluequartzsoftware/simplnx](https://www.github.com/bluequartzsoftware/simplnx) and submit a PR for the change.
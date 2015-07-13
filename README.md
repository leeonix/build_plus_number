# build_plus_number

####useage: `lua buildpp.lua build`
parameter `build` add one build number
parameter `release` add one release number

`buildapp.lua` excute first time will create `version.h` and `number.inc` in build path.
other time read version number from `number.inc`, and plus it.

but default corporation info is `Microsoft` ;-)
if change these. create `info.txt` in `version.h` same path like these:
```C
#define STR_AppName             TEXT("Your App Name")
#define STR_Filename            TEXT("Your File Name")
#define STR_Author              TEXT("Your Name")
#define STR_Corporation         TEXT("Your Corporation")
#define STR_Description         TEXT("Your Description.")
#define STR_Copyright           TEXT("Your CopyRight") 
```
`buildapp.lua` will read it.

### Use in Visual Studio
add version.rc's content to your resource file,
or use #include.
```C
#include version.rc
```
add `lua buildpp.lua build` to `PreBuildEvent`.
you can plus one build number in every build.

### hi gloopbloop
here is how to set this up (hopefully)

- download and install haxe from [here](https://haxe.org/download/)
- might need to restart idk
- run the following commands in cmd: `haxelib install godot`, `haxelib install hxcs`
- download godot mono from [here](https://godotengine.org/download/windows)
- dont use github desktop for this setup (it might break something idk, but if you really want to after you set it up it should be fine)
- in cmd, `cd` to the dir you want to have the repository be in (its basically the same as `cd` on linux)
- run the following commands: `git clone --recurse-submodules https://github.com/Team-Prism/ranodm.git`, `code .`
- if `code .` doesnt open vscode just open the `ranodm` folder with vscode manually
- download the [Haxe](https://marketplace.visualstudio.com/items?itemName=nadako.vshaxe), [C# Tools for Godot](https://marketplace.visualstudio.com/items?itemName=neikeq.godot-csharp-vscode), [godot-tools](https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools), and [C#](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp) extensions
- open the mono build of godot and open the `project.godot` file in the repository folder.
- it should work

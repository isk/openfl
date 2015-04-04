package openfl.display3D._shaders;

// TODO: Remove

#if flash
typedef Shader = flash.utils.ByteArray;
#elseif (cpp || neko || js)
typedef Shader = lime.graphics.opengl.GLShader;
#end
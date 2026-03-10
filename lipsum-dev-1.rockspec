rockspec_format = "3.0"
package = "lipsum"
version = "dev-1"
source = {
   url = "git+https://github.com/ProCern/lua-lipsum.git"
}
description = {
   summary = "Lorem Ipsum generator",
   detailed = "Lorem Ipsum generator in Lua, with multiple options for generating specific shapes of text",
   homepage = "https://github.com/ProCern/lua-lipsum",
   license = "MPL-2.0"
}
dependencies = {
   "lua >= 5.1, < 5.6",
   queries = {
      {
         constraints = {
            {
               op = ">=",
               version = {
                  5, 1, string = "5.1"
               }
            },
            {
               op = "<",
               version = {
                  5, 6, string = "5.6"
               }
            }
         },
         name = "lua"
      }
   }
}
build = {
   type = "builtin",
}

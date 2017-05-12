require "import"
import "android.widget.*"
import "android.content.*"
import "android.support.v4.view.ViewPager"
import "android.support.v7.widget.Toolbar"
import "androlua.LuaActivity"
local layout = require "main.layout_main"

activity.setTitle('LuaFileActicity')


function newActivity(luaPath)
    local intent = Intent(activity,LuaActivity)
    intent.putExtra("luaPath",luaPath)
    activity.startActivity(intent)
end

function onCreate(savedInstanceState)
    activity.setContentView(loadlayout(layout))
    btn_text.onClick = function()
        newActivity("text/activity_text.lua")
    end
    btn_image.onClick = function()
        newActivity("image/activity_image.lua")
    end
end

function  onCreateOptionsMenu(menu)
    menu.addSubMenu("setting")
    menu.addSubMenu("about")
end
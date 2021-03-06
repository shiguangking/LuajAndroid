--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/29
-- A zhihu daliy app
--
require "import"
import "android.widget.*"
import "android.content.*"
import "android.support.v4.view.ViewPager"
import "android.support.design.widget.TabLayout"
local LuaFragmentPageAdapter = luajava.bindClass("androlua.LuaFragmentPageAdapter")
local JSON = require("common.json")
local uihelper = require("common.uihelper")
local Http = luajava.bindClass("androlua.LuaHttp")

local fragment = require "zhihudaliy/fragment_zhihu_daliy"

-- create view table
local layout = {
    LinearLayout,
    layout_width = "fill",
    layout_height = "fill",
    orientation = "vertical",
    fitsSystemWindows = true,
    {
        TabLayout,
        id = "tab",
        layout_width = "fill",
        layout_height = "48dp",
        background = "#16A0EA",
        elevation = "2dp",
    },
    {
        ViewPager,
        id = "viewPager",
        layout_width = "fill",
        layout_height = "fill",
    },
}

local data = {
    titles = {},
    fragments = {},
}

table.insert(data.fragments, fragment.newInstance())
table.insert(data.titles, '首页')

local adapter = LuaFragmentPageAdapter(activity.getSupportFragmentManager(),
    luajava.createProxy("androlua.LuaFragmentPageAdapter$AdapterCreator", {
        getCount = function() return #data.fragments end,
        getItem = function(position)
            position = position + 1
            return data.fragments[position]
        end,
        getPageTitle = function(position)
            position = position + 1
            return data.titles[position]
        end
    }))

function getData()
    Http.request({url="http://news-at.zhihu.com/api/4/themes"}, function ( error,code,body )
        local themes  =  JSON.decode(body).others
        for i=1,#themes do
          table.insert(data.titles, themes[i].name)
          table.insert(data.fragments, fragment.newInstance(themes[i].id))
        end
        runOnUiThread(activity,function ()
          adapter.notifyDataSetChanged()
        end)
    end)
  end

function onCreate(savedInstanceState)
    activity.setStatusBarColor(0xff16A0EA)
    activity.setContentView(loadlayout(layout))
    viewPager.setAdapter(adapter)
    tab.setSelectedTabIndicatorColor(0xffffffff)
    tab.setTabTextColors(0x88ffffff, 0xffffffff)
    tab.setTabMode(TabLayout.MODE_SCROLLABLE)
    tab.setTabGravity(TabLayout.GRAVITY_CENTER)
    tab.setupWithViewPager(viewPager)
    getData()
end



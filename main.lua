m = {}
math.randomseed(os.time())
function m.load()
	love.graphics.setDefaultFilter("nearest","nearest")
	Texture = {
		Tile = love.graphics.newImage("/Texture/Tile.png"),
		Player = love.graphics.newImage("/Texture/PlayerD.png"),
		Block = love.graphics.newImage("/Texture/Block.png"),
		Water = love.graphics.newImage("/Texture/Water.png"),
		Fire = love.graphics.newImage("/Texture/Fire.png"),
		Dummy = love.graphics.newImage("/Texture/PlayerR.png"),
		Teeth = love.graphics.newImage("/Texture/TeethR.png")
	}
	local x,y = love.window.getDesktopDimensions()
	screen = {x=x,y=y,frameSize=32,px=0.03125} -- plz only use 32!
	dummy = {x=-1,c=0}
	love.window.setMode(screen.x,screen.y)
	
	smooth = 0
	
	local add = function(x,y,kind)
		local c = {x=x,y=y,kind=kind}
		table.insert(PosObjects,c)
	end
	local draw = {
		"bbbb  ffff  w   w  ",
		"b     f     w   w  ",
		"b     f     w   w  ",
		"bbbb  ffff  w w w  ",
		"b     f     w w w  ",
		"b     f      w w   ",
		"bbbb  f      w w   ",
	}
	local readF = function()
		for y = 1,#draw do
			for x = 1,#draw[y]do
				local n = string.upper(string.sub(draw[y],x,x))
				for i,_ in pairs(Texture)do
					if string.sub(i,1,1) == n then
						add(x,y,i)
						break
					end
				end
			end
		end
	end
	
	PosObjects = {}
	readF()
	
	
	Tiles = {}
	for x = 0,math.floor(screen.x/screen.frameSize) do
		for y = 0,math.floor(screen.y/screen.frameSize) do
			local n = string.char(x+32)..string.char(y+32)
			local kind = "Tile";
			for _,v in pairs(PosObjects)do
				if v.x == x and v.y == y then
					kind = v.kind
				end
			end
			Tiles[n] = {x=x,y=y,show=false,kind=kind}
		end
	end
	
	index = {}
	for i,_ in pairs(Tiles)do
		table.insert(index,i)
	end
end

function m.update()
	local r = 5
	if #index <= 20 then
		r = 1
	end
	for _ = 0,r do
		if #index ~= 0 then
			local n = math.random(#index) 
			Tiles[index[n]].show = true
			table.remove(index,n)
		end
	end
	if #index == 0 and smooth <= 15 then
		smooth = smooth + 0.2
	end
	
	if smooth >= 15 and dummy.x <= 15 then
		if dummy.c >= 10 then
			dummy.x = dummy.x + 1
			dummy.c = 0
		end
		dummy.c = dummy.c + 1
	end
end

function m.draw()
	local px = screen.px*screen.frameSize
	local sf = screen.frameSize
	love.graphics.setColor(255,255,255)
	for _,v in pairs(Tiles)do
		if v.show == true then
			if v.kind == "Fire" then
				love.graphics.draw(Texture.Tile,v.x*sf,v.y*sf,0,px,px)
			end
			love.graphics.draw(Texture[v.kind],v.x*sf,v.y*sf,0,px,px)
		end
	end
	
	love.graphics.draw(Texture.Dummy,dummy.x*sf,10*sf,0,px,px)
	love.graphics.draw(Texture.Teeth,(dummy.x-3)*sf,10*sf,0,px,px)
	
	if #index == 0 then
		love.graphics.rectangle("fill",math.floor(screen.x/sf/3)*sf,5*sf,(smooth-0.2)*sf,11*sf)
	end
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 550, 50)
end



function love.load()
	m.load()
end
function love.update()
	m.update()
end
function love.draw()
	m.draw()
end

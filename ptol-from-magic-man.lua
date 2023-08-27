--author:  game developer, email, etc.
--desc:    short description
--site:    website link
--license: MIT License (change this to your license of choice)
--version: 0.1
--script:  lua

function BOOT()
	menutiles = {
		logo = {
	[392] = {1,1},
	[393] = {2,1},
	[394] = {3,1},
	[395] = {4,1},
	[396] = {5,1},
	[408] = {1,2},
	[409] = {2,2},
	[410] = {3,2},
	[411] = {4,2},
	[412] = {5,2},
	[413] = {6,2},
	[414] = {7,2},
	},
	icon = {
		[331] = {8,1},
		[347] = {8,2},
		[363] = {8,3},

		[332] = {8,0},
		[364] = {8,4.7},
	}
	}

	gamestate = "mainmenu"

	trace("START HERE ---------")
	gravity = 0.2
	accelx = 0.3
	decelx = 0.8
	jump = 2.75
	maxaccel = 5


	--tags
	--0 = player solid
	--1 = portal surface
	--2 = can let through
	--3 = fizzle
	mapcontent = {
		objectlist = {
			orangeportal,
			blueportal,
			
		},
		interactablelist = {
		},
		entitylist = {
		},
		turretlist = {

		},
	}
	renderorder = {
		mapcontent.objectlist,
		mapcontent.interactablelist,
		mapcontent.entitylist,
	}

	maplist = {
		current = 1,
		[1] = {1,1},
		[2] = {2,1},
	}
	mapnames = {
		[1] = "1 - P-TOL",
		[2] = "2 - Wheato",
	}

	tiletypes = {
		[64] = {"cube","interactable",true,false,64,{["true"]=64,["false"]=64},0,00,"x","y",1,{0,0,8,8},nil,{"interactablelist","entitylist"}},
		[32] = {"button","activator",false,true,32,{["true"]=32,["false"]=33},0,00,"x","y",1,{1,6,14,2},"door1",{"interactablelist","objectlist"}},
		[49] = {"button","clickable",false,false,49,{["true"]=49,["false"]=49},0,00,"x","y",1,{0,0,8,8},"door1",{"interactablelist","objectlist"}},
		[81] = {"prop","door",false,false,81,{["true"]=97,["false"]=81},0,00,"x","y",1,{0,0,8,8},nil,{"interactablelist","objectlist"}},
		[65] = {"turret","x","y",1,{0,0,8,8},{"turretlist","interactablelist","entitylist"}}
	}
	entitycounts = {
		["button"] = 0,
		["cube"] = 0,
		["turret"] = 0,
		["prop"] = 0,
	}

	orangeportal = newPortal("orangeportal")
	blueportal = newPortal("blueportal")

	UIlist, UIelems, wheatleyface = getUI()
	t=1
	pcollidetime = 6
	portalcooldown = 0
	useCooldown = 0
	loadMap()

	music(0,0,0,true,true)
end




function loadMap()
	--x of maptiles, y of maptiles, no to draw, 
	local offsetx = (maplist[maplist.current][1]-1)*30
	local offsety = (maplist[maplist.current][2]-1)*29


	for x = 0,29 do
		for y = 0,16 do
		local tile = mget(offsetx + x, offsety + y)
		if tile == 128 then
			player,gun = newPlayer(x,y)
			mset(offsetx + x, offsety + y,15)
		end
		--elseif tile == 64 then
		if tiletypes[tile] then --if tile exists that has special function

				local object
			if tiletypes[tile][#tiletypes[tile]][1] == "interactablelist" then --if first entry of types has interactable then assign it to be interactable
				object = newInteractable(loadSprite(tile,x,y))
			end
			if tiletypes[tile][#tiletypes[tile]][1] == "objectlist" then --if first entry of types has object then assign it to be interactable
				object = newObject(loadSprite(tile,x,y))
			end
			if tiletypes[tile][#tiletypes[tile]][1] == "turretlist" then
				object = newTurret(loadSprite(tile,x,y))
			end

			for _,tble in pairs(tiletypes[tile][#tiletypes[tile]]) do
				if tble=="entitylist" then
					--table.insert(mapcontent.entitylist,object[1],object)
					mapcontent.entitylist[object.name] = object
				elseif tble=="interactablelist" then
					--table.insert(mapcontent.interactablelist,object[1],object)
					mapcontent.interactablelist[object.name] = object
				elseif tble=="objectlist" then
					--table.insert(mapcontent.objectlist,object[1],object)
					mapcontent.objectlist[object.name] = object
				elseif tble=="turretlist" then
					--table.insert(mapcontent.objectlist,object[1],object)
					mapcontent.turretlist[object.name] = object
				end
			end
			
			mset(offsetx + x, offsety + y,15)
		end
	end
	end
	for x,val in pairs(mapcontent) do
		for _,v in pairs(val) do
			trace(x)
			trace(_.." "..v.name)
		end
	end
	
	--return player,gun
end

function loadSprite(tile, x,y)

	local temp = {}
	for k, v in pairs(tiletypes[tile]) do temp[k] = v end
	entitycounts[tiletypes[tile][1]] = entitycounts[tiletypes[tile][1]]+1
	temp[1] = temp[1]..entitycounts[tiletypes[tile][1]]

	for _,val in pairs(temp) do
		if val == "x" then
			temp[_] = x*8
		elseif val == "y" then
			temp[_] = y*8
		end
	end
	return table.unpack(temp)
end



function getUI()
	local UIlist = {
		
		{0,104,240,32,00},

		{2,108,77,1,14},
		{2,109,77,30,15},

		{82,108,76,1,14},
		{82,109,76,30,15},

		{161,108,37,1,14},
		{161,109,37,30,15},

		{201,108,37,1,14},
		{201,109,37,30,15},

		{41,110,34,1,13},
		{41,111,34,9,14},

		{41,122,34,1,13},
		{41,123,34,10,14},


		{86,111,70,23,14},
		{87,112,68,21,00},
	}
	local UIelems = {
		oportal = {{496,0},{496,1},{496,2},{496,3}},
		bportal = {{497,0},{497,1},{497,2},{497,3}},
		noportal = {{498,0},{498,1},{498,2},{498,3}},
		heart = 499,
		noheart = 500,
		coin = 501,
		nocoin = 502,
		core = {{464,0},{464,1},{480,0},{480,1}}
	}

	local wheatleyface = {
		etop = {state=0, 
			{[5] = {15,14,13,14,15},  
			[6] = {14,15,13,13,14}
			}
		},
		ebot = {state=0, {[1] = {14,14,14,14,14}, [2] = {15,15,15,15,15}}},
	}
	return UIlist, UIelems, wheatleyface
end

function newPlayer(xx,yy)
	local player = {}
	player.name = "player"
	player.spval = 256
	player.splist = {idle={256,257},run={258,259}}
	player.x = xx*8
	player.y = yy*8
	player.nodraw = 00
	player.scale = 1
	player.flip = false
	player.rotate = 0

	player.gravity = gravity
	player.dogravity = true
	player.ax = accelx
	player.ay = jump
	player.dx = decelx
	player.maxax = maxaccel
	player.vx = 0
	player.vy = 0

	player.state = "idle"
	player.draw = true
	player.dotilecollide = {true,true,true}
	player.doportalcollide = true
	player.excludeportal = false
	player.portalcollidelen = 0
	player.isHolding = nil
	player.outline = {false,12}

	player.hearts = 3
	player.coins = 1

	mapcontent.entitylist[player.name] = player
	return player, newGun(player)
end
function newGun(player)
	local gun = {}

	gun.name = "gun"
	gun.spval = 272
	gun.splist = {272,273,288}
	gun.x = player.x
	gun.y = player.y
	gun.nodraw = 00
	gun.scale = 1
	gun.flip = player.flip
	gun.rotate = 0

	gun.gravity = 0
	gun.dogravity = false
	gun.ax = 0
	gun.ay = 0
	gun.dx = 0
	gun.maxax = 0
	gun.vx = 0
	gun.vy = 0
	gun.rect = {0,0,0,0}
	gun.state = nil
	gun.draw = true
	gun.dotilecollide = {false,false,false}
	gun.doportalcollide = false
	gun.portalcollidelen = 0
	gun.excludeportal = true
	gun.outline = {false,12}
	gun.ignore = true
	gun.type="gun"

	mapcontent.entitylist[gun.name] = gun
	return gun
end
function newPortal(type)
	local portal = {}
	portal.name = type
	if type=="orangeportal" then portal.spval = 274
	else portal.spval = 275 end
	portal.nodraw = 00
	portal.scale = 1
	portal.state = 1
	portal.flip = false
	portal.rotate = 0
	portal.draw = false
	portal.face = 1
	portal.dotilecollide = {false,false,false}

	portal.x = -1
	portal.y = -1
	portal.gravity = 0
	portal.dogravity = false
	portal.ax = 0
	portal.ay = 0
	portal.dx = 0
	portal.maxax = 0
	portal.vx = 0
	portal.vy = 0
	portal.rect = {0,0,0,0}
	portal.type="portal"
	portal.ignore = true

	portal.outline = {false,12}
	portal.excludeportal = true

	mapcontent.entitylist[portal.name] = portal
	return portal
end

function newTurret(name,xx,yy,scale,rect)
	local entity = {}
	entity.type = "turret"
	entity.name = name
	entity.spval = 65
	entity.splist = {["true"]=97,["false"]=65}
	entity.nodraw = 00
	entity.x = xx
	entity.y = yy
	entity.cangrab = true


	entity.gravity = gravity
	entity.dogravity = true
	entity.ax = accelx
	entity.ay = jump
	entity.dx = decelx
	entity.maxax = maxaccel
	entity.vx = 0
	entity.vy = 0



	entity.firetimer = 0
	entity.scale = scale
	entity.rect = rect
	entity.draw = true
	entity.flip = false
	entity.outline = {false,12}
	entity.grabbable = true
	entity.portalcollidelen = 0
	entity.canmove = true
	entity.dotilecollide = {true,true,true}

	return entity
end



function newObject(name,spval,splist,xx,yy,scale,rect,multi,typer)
	local object = {}
	object.name = name
	object.spval = spval
	object.splist = splist
	object.x = xx
	object.y = yy
	object.scale = scale
	object.rect = rect
	object.multi = multi
	object.type = typer
	object.nodraw = 00
	object.draw = true
	object.outline = {false,12}
	

	return object
end
function newInteractable(name,objtype,grabbable,multi,spval,splist,flip,ndraw,xx,yy,scale,rect,clickable,linkname)
	local entity = {}
	entity.type = objtype
	entity.cangrab = grabbable
	entity.spval = spval
	entity.splist = splist
	entity.draw = true
	entity.x = xx
	entity.y = yy
	entity.scale = scale
	entity.state = false
	entity.outline = {false,12}
	entity.name = name
	entity.flip = flip
	entity.colliding = {true,true,true}
	
	entity.nodraw = ndraw
	entity.vx = 0
	entity.vy = 0
	entity.ax = 0
	entity.ay = 0
	entity.dx = 0
	entity.maxax = 0
	entity.rect = rect
	entity.portalcollidelen = 0
	entity.multi = multi
	
	if objtype == ("activator") then
		entity.link = linkname
		entity.dogravity = false
		entity.gravity = 0
		entity.canmove = false
		entity.dotilecollide = {false,false,false}
		entity.outline = {false,06}
	elseif objtype == ("clickable") then
		entity.link = linkname
		entity.dogravity = false
		entity.gravity = 0
		entity.canmove = false
		entity.dotilecollide = {false,false,false}
		entity.clickable = true
		entity.timer = 0
		entity.outline = {false,02}
	else
		entity.dotilecollide = {true,true,true}
		entity.canmove = true
		entity.gravity = gravity
		entity.dogravity = true
	end

	return entity
end


function boolToVal(input)
	local booltoval = {[true]=1,[false]=0, [2]=2, [3]=3}
	return booltoval[input]
end
function gmouse()
	local m = {}
	m.x,m.y,m.left,m.middle,m.right,m.scrollx,m.scrolly = mouse()
	return m
end
function drawLine(p1,p2,clr)
	line(p1.x+4,p1.y+4,p2.x+4,p2.y+4,clr)
end

function drawtextoutline(text,x,y,colour)
	print(text,x-1,y,colour)
	print(text,x+1,y,colour)
	print(text,x,y+1,colour)
	print(text,x,y-1,colour)
end

function draw(sprite)
	if sprite.outline[1] then
		for x=0,15,1 do
			poke4(0x3FF0*2+x,sprite.outline[2])
		end

		spr(sprite.spval,sprite.x-1,sprite.y,0,1,boolToVal(sprite.flip))
		spr(sprite.spval,sprite.x+1,sprite.y,0,1,boolToVal(sprite.flip))
		spr(sprite.spval,sprite.x,sprite.y+1,0,1,boolToVal(sprite.flip))
		spr(sprite.spval,sprite.x,sprite.y-1,0,1,boolToVal(sprite.flip))

		if sprite.multi then
			spr(sprite.spval,sprite.x+8+1,sprite.y,0,1,boolToVal(true))
			spr(sprite.spval,sprite.x+8,sprite.y+1,0,1,boolToVal(true))
			spr(sprite.spval,sprite.x+8,sprite.y-1,0,1,boolToVal(true))
		end
		for c=0,15 do
			poke4(0x3FF0*2+c,c)
		end
	end

	if sprite.draw then
		if sprite.multi then
			spr(sprite.spval, sprite.x+8, sprite.y, sprite.nodraw,sprite.scale,boolToVal(true),sprite.rotate)
		end
		spr(sprite.spval, sprite.x, sprite.y, sprite.nodraw,sprite.scale,boolToVal(sprite.flip),sprite.rotate)
	end
end



function getPortalrect(portal)
	if portal.face==1 then
		return portal.x,portal.y,2,8
	elseif portal.face==2 then
		return portal.x,portal.y,8,2
	elseif portal.face == 3 then
		return portal.x+6,portal.y,2,8
	elseif portal.face==4 then
		return portal.x,portal.y+6,8,2
	end
end
function getInteractrect(sprite)
	--rect(sprite.x+sprite.rect[1],sprite.y+sprite.rect[2],sprite.rect[3],sprite.rect[4],2)
	return sprite.x+sprite.rect[1],sprite.y+sprite.rect[2],sprite.rect[3],sprite.rect[4]
end
	

function sprmega(sprite,x,y,nodraw)
	local xz=0
	local yz=0
		for _,sp in pairs(sprite) do
			if xz>1 then
				xz=0
				yz=8
			end
			spr(sp[1],x+((xz)*8),y+yz,nodraw,1,sp[2])
			xz=xz+1
		end
end

function drawUI()
	
	for _,pos in pairs(UIlist) do
		rect(pos[1],pos[2],pos[3],pos[4],pos[5])
	end	

	
	local x = 0
	local y = 0

	

	sprmega(UIelems.noportal,90,114,00)
	sprmega(UIelems.noportal,136,114,00)
	

	for x=1,3 do
		spr(UIelems.noheart, 46+((x-1) *9 ), 111, 06)
		spr(UIelems.nocoin, 45+((x-1) *10 ), 124, 06)
	end
	
	print("HEALTH",5,113,00)
	print("HEALTH",4,112,02)
	print("COINS",5,126,00)
	print("COINS",4,125,03)


	
	
end
function solid(x,y)
	return fget(mget((x//8) + ((maplist[maplist.current][1]-1)*30),(y)//8),0)
end
function solidportal(x,y,type)
	return fget(mget((x//8) + ((maplist[maplist.current][1]-1)*30),(y)//8),type)
end

function spriteoverlap(ax,ay,aw,ah, bx,by,bw,bh)
	return ax<bx+bw and bx<ax+aw and ay<by+bh and by<ay+ah
end

function spriteoverlapall(ax,ay,aw,ah,name)
	for _,val in pairs(mapcontent.objectlist) do 
		if spriteoverlap(ax,ay,aw,ah,getInteractrect(val)) and name ~= val.name and val.draw then
			return true 
		end
	end
	return false
end

function UIinteractable()
	if orangeportal.draw then sprmega(UIelems.oportal,90,114,00) wheatleyface.etop.state = 1 end
	if blueportal.draw then sprmega(UIelems.bportal,136,114,00) wheatleyface.ebot.state = 1 end
	for x=1,player.hearts do spr(UIelems.heart, 45+((x-1) *9 ), 111, 00) end
	for x=1,player.coins do spr(UIelems.coin, 44+((x-1) *10 ), 124, 00) end


	if wheatleyface.etop.state > 0 then
		replacepixarea(UIelems.core[1][1],wheatleyface.etop[1],{5,5},{7,6})
		wheatleyface.etop.state = wheatleyface.etop.state-0.05
	end
	if wheatleyface.ebot.state > 0 then
		replacepixarea(UIelems.core[3][1],wheatleyface.ebot[1],{5,1},{7,2})
		wheatleyface.ebot.state = wheatleyface.ebot.state-0.05
	end


	sprmega(UIelems.core,112,114,6)
end

function velocity()
	for _,sprite in pairs(mapcontent.entitylist) do
		if math.abs(sprite.vy) > (4.5 ) then
			if sprite.vy < 0 then sprite.vy = (-4.5 ) else sprite.vy = (4.5) end
		end


		sprite.x = sprite.x + (sprite.vx)
		sprite.y = sprite.y + (sprite.vy)



		sprite.vx = sprite.vx*(sprite.dx )
		if math.abs(sprite.vx) < (0.05 ) then sprite.vx = 0 end
	end
	for _,sprite in pairs(mapcontent.interactablelist) do
		if sprite.canmove then
			if math.abs(sprite.vy) > (4.5 ) then
				if sprite.vy < 0 then sprite.vy = (-4.5 ) else sprite.vy = (4.5) end
			end


			sprite.x = sprite.x + (sprite.vx)
			sprite.y = sprite.y + (sprite.vy)



			sprite.vx = sprite.vx*(sprite.dx )
			if math.abs(sprite.vx) < (0.05 ) then sprite.vx = 0 end
		end
	end
end

function collideTile()
	for _, sp in pairs(mapcontent.entitylist) do
		


		sp.colliding = {false,false,false}

		floor={nil}
		roof={nil}
		side={nil}
		side2={nil}
		if sp.dotilecollide[1] then floor = {solid(sp.x+2, sp.y+sp.vy+8), solid(sp.x+6, sp.y+sp.vy+8)}  end
		if sp.dotilecollide[2] then roof = {solid(sp.x+2, sp.y+sp.vy), solid(sp.x+6, sp.y+sp.vy)} end
		if sp.dotilecollide[3] then 
			side = {solid(sp.x+sp.vx+1, sp.y+2), solid(sp.x+sp.vx+1, sp.y+6)}
			side2 = {solid(sp.x + sp.vx+6, sp.y+2), solid(sp.x + sp.vx+6, sp.y+6)}
		end
		
				--floor collision
			if floor[1] or floor[2] then
				
				sp.vy = 0
				if (solid(sp.x+2,sp.y+8) and solid(sp.x+6,sp.y+8)) and (sp.y+sp.vy+8) % 8 ~= 0 then
					sp.y = sp.y - (sp.y+sp.vy+8) % 8
				end
				sp.colliding[1] = true
			else --apply gravity
				if sp.dogravity then
					sp.vy = sp.vy+(sp.gravity)
					sp.colliding[1] = false
				end
				
			end
		--roof collision
		if roof[1] or roof[2] then
			sp.vy = math.abs(sp.vy)
			sp.colliding[2] = true
		else
			sp.colliding[2] = false
		end
		--side collision
		if side[1] or side[2] or side2[1] or side2[2] then
			sp.vx = 0
			sp.colliding[3] = true
		else
			sp.colliding[3] = false
		end

		collideInteractables(sp)

		collideObjects(sp)
		
	end
end

function collideObjects(spr)
	--for _,spr in pairs(mapcontent.entitylist) do
		for _,obj in pairs(mapcontent.objectlist) do

			if spr.draw and obj.draw and spr.name ~= obj.name and not spr.ignore and not obj.ignore and (obj.type == "activator" or (obj.type == "prop" and obj.state==false)) then

				local sides = spriteoverlap(spr.x+spr.vx,spr.y+spr.vy,8,8, getInteractrect(obj))
					--local sideleft = spriteoverlap(spr.x,spr.y,1,8, obj.x+7,obj.y+1,1,6)
				local roof = spriteoverlap(spr.x+spr.vx+1,spr.y+spr.vy+6,6,4, getInteractrect(obj))
				if roof then
					if spr.y+8 < obj.y+8 then
						if not spr.colliding[1] then
							spr.colliding[1] = true
						end
						if spr.vy > 0 then
							spr.vy=0
						end
					end
					
				end
				if sides then
					spr.colliding[3] = true
					obj.colliding[3] = true
					if obj.rect[4] < 4 then
						spr.y = spr.y-obj.rect[2]
						if spr.vy > 0 then
							spr.vy=0
						end
					end
					if spr.x > obj.x+8 and spr.vx < 0 then
						spr.vx=0
					elseif spr.x+8 < obj.x and spr.vx > 0 then
						spr.vx =0 
					end
					
				end
				if sides or roof then
					obj.state = true
				end
			end
			if obj.clickable then
				if spriteoverlap(spr.x,spr.y,8,8,getInteractrect(obj)) then
					obj.inrange = true
				end
			end
		end
	--end
end

function collideInteractables(spr)
		for _,obj in pairs(mapcontent.interactablelist) do
			if spr.draw and obj.draw and obj.canmove and spr.name ~= obj.name and not spr.ignore and not obj.ignore then
				local sides = spriteoverlap(spr.x+spr.vx+1,spr.y+spr.vy+1,6,6, getInteractrect(obj))
				local roof = spriteoverlap(spr.x+1,spr.y+4+spr.vy,6,4, getInteractrect(obj))
				local floor = spriteoverlap(spr.x+1,spr.y,6,2,getInteractrect(obj))
				local inblock = spriteoverlap(spr.x+1,spr.y+spr.vy,6,6,getInteractrect(obj))

				if inblock then
					if spr.x < obj.x then
						if spr.vx > 0 then
							spr.vx=0
						end
					elseif spr.x > obj.x then
						if spr.vx < 0 then
							spr.vx=0
						end
					elseif spr.x < obj.x then
						if spr.vx < 0 then
							spr.vx=0
						end
						if spr.vx > 0 then
							spr.vx=0
						end
					end
				end

				if roof then --top of cube
					--if obj.colliding[1] then
						spr.colliding[1] = true
						if spr.vy > 0 then
							spr.vy=0
						end
					--end
				end
				if floor and not roof then
					obj.colliding[1] = true
					if spr.vy > 0 then
						spr.vy=0
					end
					if obj.vy > 0 then
						obj.vy=0
					end
				end
				if sides then
					if not obj.colliding[3] then
						if spr.x < obj.x and spr.vx > 0 then
								obj.vx = spr.vx
								spr.vx = obj.vx
						elseif spr.x+8 > obj.x+8 and spr.vx < 0 then
							obj.vx = spr.vx
							spr.vx = obj.vx
						end
					else
						
						if spr.x < obj.x and spr.vx > 0 then
							spr.vx = 0
						elseif spr.x+8 > obj.x+8 and spr.vx < 0 then
							spr.vx = 0
						end
					end
				end
			end
		end
end

function holdobject(sprite)
	object = sprite.isHolding
	local m = gmouse()	
	local angle, l = getAngleDistance(sprite,gmouse())
	

	if length > 12 then length = 12 end
	if sprite.vy == 0 then
		if (math.deg(angle) > 15 and math.deg(angle) < 90) then
			angle = math.rad(25)
		elseif (math.deg(angle) > 90 and math.deg(angle) < 181) then
			angle = math.rad(165)
		end
	end

	local tx = (length * math.cos(angle) + sprite.x)
	local ty = (length * math.sin(angle) + sprite.y)

	if length < 2 or not object.doportalcollide then
		dropobject(sprite)
	end
	if solid(tx+8+sprite.vx,ty+4+sprite.vy) or solid(tx+sprite.vx,ty+4+sprite.vy) or solid(tx+4+sprite.vx,ty+6) or spriteoverlapall(tx+1,ty+1,6,6,object.name) then --or solid(tx+10+sprite.vx,ty+4+sprite.vy) or solid(tx+4+sprite.vx,ty+7+sprite.vy) then
		length = length - 1
		tx = (length * math.cos(angle) + sprite.x)
		ty = (length * math.sin(angle) + sprite.y)
		
		--length = getAngleDistance({x=tx+8+sprite.vx, y=ty+4+sprite.vy},object)
	else
		if length < 12 then
			length = length+1
		end
	end

	object.x = tx
	object.y = ty

	if object.x < sprite.x then
		object.flip = true
	else
		object.flip = false
	end
	portalcooldown = 8
end

function grabobject(sprite)
	local angle,maxl = getAngleDistance(sprite,gmouse())

	length = 2
	if maxl > 46 then
		return
	end

	while length < maxl do
		ax = length * math.cos(angle) + sprite.x+4
		ay = length * math.sin(angle) + sprite.y+4

		pix(ax,ay,2)
		for _,obj in pairs(mapcontent.interactablelist) do
			if obj.cangrab and obj.draw then
				if solid(ax,ay) then
					return
				end

				if spriteoverlap(ax,ay,2,2, obj.x,obj.y,8,8) then
					player.isHolding = obj
					obj.dogravity = false
					return true
				end
			end
		end

		if solid(ax,ay) then
			maxl = length-1
		end
		length=length+4
	end
	return nil

end

function dropobject(sprite)
	sprite.isHolding.dogravity = true
	sprite.isHolding = nil
end

function getAngleDistance(sprite,object)
	local xval = (object.x - sprite.x) * (object.x - sprite.x) 
	local yval = (object.y-sprite.y) * (object.y-sprite.y)

	local angle = math.atan2(object.y - sprite.y, object.x - sprite.x)
	local length = (math.sqrt(xval + yval))

	return angle, length
end

function gunUpdate()
	local m = gmouse()

	if m.left and portalcooldown == 0 then
		makePortal(orangeportal)
		if orangeportal.x == blueportal.x and orangeportal.y == blueportal.y then
			orangeportal.draw = false
		end
		portalcooldown = 8
	end
	if m.right and portalcooldown == 0 then
		makePortal(blueportal)
		if orangeportal.x == blueportal.x and orangeportal.y == blueportal.y then
			blueportal.draw = false
		end
		portalcooldown = 8
	end
	if m.middle or solidportal(gun.x+4,gun.y+4,3) then
		orangeportal.draw = false
		blueportal.draw = false
		orangeportal.x= -1
		orangeportal.y= -1
		blueportal.x= -1
		blueportal.y= -1
		
	end
	gunSpriteState()
	gun.scale = player.scale
	gun.x = player.x+2
	gun.y = player.y-1
	gun.flip = player.flip
	if gun.flip then
		gun.x = player.x-2
	end
	if portalcooldown > 0 then
		portalcooldown = portalcooldown-1
	end
end
function gunSpriteState()
	if orangeportal.draw and blueportal.draw then
		poke(0x3FFB,264)
		gun.spval = gun.splist[3]
	elseif orangeportal.draw then
		poke(0x3FFB,262)
		gun.spval = gun.splist[2]
	elseif blueportal.draw then
		poke(0x3FFB,261)
		gun.spval = gun.splist[1]
	else
		poke(0x3FFB,263)
		gun.spval = gun.splist[1]
	end

	if portalcooldown > 0 then
		poke(0x3FFB,264)
		gun.spval = gun.splist[3]
	end
end

function raycast(angle)
	local length = 2
	local px = player.x
	local py = player.y
	local r = 0
	local f = false
	
	local sidec = false
	local side2 = false
	local floorc = false
	local roofc = false

	while true do
		ax = length * math.cos(angle) + px
		ay = length * math.sin(angle) + py
		
	
		inblock = solid(ax+4,ay+4)
		floor = {solid(ax+1,ay+6),solid(ax+7,ay+6)}
		roof = solid(ax+4, ay-1)
		side = {solid(ax+1, ay), solid(ax+1,ay+8)}
		side2 = {solid(ax+7, ay), solid(ax+7,ay+8)}
		
		if spriteoverlapall(ax+4,ay+4,1,1,"temp") then return end
		if solidportal(ax,ay,2) then return end
		ay = math.floor((ay/8)+0.5)*8
		ax = math.floor((ax/8)+0.5)*8
		
		if not inblock then
		--side collision
			if side[1] and side[2] then
				sidec = true
				f = true
				r = 0
			end
			if side2[1] and side2[2] then
				sidec = true
				f = false
				r = 0
				
			end
			
				--floor collision
			if floor[1] and floor[2] then
				floorc = true
			end
			
			--roof collision
			if roof then
				roofc = true
			end
		else
			roofc = true
			ay=ay+8
		end
		
		if sidec or floorc or roofc then
			if floorc and not sidec and not roofc then --if floor detect, rotate down
				r = 1
				f = false
			end
			if roofc and not sidec and not floorc then
				r = 3
				f = false
			end


			if r==1 then
				ty = ay+8
				tx = ax
			elseif r==3 then
				ty = ay-8
				tx = ax
			else
				if f then
					ty = ay
					tx = ax-8
				else
					ty = ay
					tx = ax+8
				end
			end
			if solidportal(tx,ty,1) then
				return {ax,ay,r,f}
			else
				return nil
			end
		end
		length = length+0.5
	end
	return nil
end
function makePortal(portalcol)
	local angle,l = getAngleDistance(player,gmouse())

	local output = raycast(angle)
	if output then
		portalcol.x = output[1]
		portalcol.y = output[2]
		portalcol.rotate = output[3]
		portalcol.flip = output[4]

		if portalcol.flip then portalcol.face = 1 else portalcol.face = 3 end --facing west, if not east
		if portalcol.rotate == 1 then portalcol.face = 4 elseif portalcol.rotate==3 then portalcol.face = 2 end  --facing down if not up
		portalcol.draw = true
		return
	end
	
end

function ObjectUpdate()
	for _,object in pairs(mapcontent.interactablelist) do
		object.spval = object.splist[tostring(not object.state)]
		object.outline[1] = object.state
		if object.clickable then
			if object.inrange then
				object.outline[1] = true
				if object.state then 
					object.outline[2] = 06 
				else
					object.outline[2] = 02
				end
			end
			if object.timer > 0 then
				object.timer = object.timer - 1
				object.state = true
			end
		end
		if solidportal(object.x,object.y,3) then
			object.draw = nil
			if player.isHolding == object then
				dropobject(player)
			end
		end

		object.state = false
		
	end

	

end

function activateobject(sprite)
	for _,obj in pairs(mapcontent.interactablelist) do
		if obj.clickable and obj.inrange then
			obj.state = true
			obj.timer = 120
		end
	end
end

function playerUpdate()
	if key(28) then
		maplist.current = 1
	elseif key(29) then
		maplist.current = 2
	end
	player.state = "idle"
	if btn(2) or key(01) and player.doportalcollide then 
		if player.vx > -player.maxax then 
			player.vx = player.vx - (player.ax) 
		end
		player.state = "left"
	end
	if btn(3) or key(04) and player.doportalcollide then 
		if player.vx < player.maxax then 
			player.vx = player.vx + (player.ax)
		end
		player.state = "right"
	end
	if btn(0) or key(48) and player.colliding[1] then
		player.vy = player.vy-(player.ay)
		player.state = "jump"
	end
	if btn(1) or key(63) then
		player.vx = player.vx*0.7
		if player.vy > 0 then
			player.vy = player.vy*(0.9)
		else
			player.vy = player.vy*(0.8)
		end
	end
	
	if key(05) and useCooldown == 0 then
		if not player.isHolding then
			
			grabobject(player)
			--activateobject(player)
		else
			dropobject(player)
		end
		useCooldown = 10
	end
	if useCooldown > 0 then
		useCooldown = useCooldown-1
	end
	playerSpriteState()

	
	if player.isHolding then
		holdobject(player,player.isHolding)
	end
end
function playerSpriteState()
	if gmouse().x < player.x then
		player.flip = true
	else
		player.flip = false
	end


	if player.state == "idle" then --idle
		player.spidx = math.floor(t/30 % #player.splist.idle) + 1
		player.spval = player.splist.idle[player.spidx]
	elseif player.state == "left" or player.state == "right" then --run
		player.spidx = math.floor(t/15 % #player.splist.run) + 1
		player.spval = player.splist.run[player.spidx]

		if player.state == "right" then --flip on direction
			player.flip = false
		else
			player.flip = true
		end
	end
end

function TurretUpdate()
	for _,obj in pairs(mapcontent.turretlist) do
		--if not obj.flip and player.x > obj.x then
			local angle,distance = getAngleDistance(obj,player)


			if not obj.flip and player.x > obj.x then
				if player.x < obj.x + 64 and (player.y < obj.y+12 and player.y > obj.y-12)  then
					obj.firetimer = obj.firetimer + 1
				end
				if player.x < obj.x + 78 and (player.y < obj.y+12 and player.y > obj.y-12)  then
					obj.seen = true
				else
					obj.seen = false
				end
			elseif obj.flip and player.x < obj.x then
				if player.x+8 > obj.x - 64 and (player.y < obj.y+12 and player.y > obj.y-12)  then
					obj.fire = obj.firetimer + 1
				end
				if player.x+8 > obj.x - 78 and (player.y < obj.y+12 and player.y > obj.y-12)  then
					obj.seen = true
				else
					obj.seen = false
				end
			else
				obj.seen = false
			end

			
			if player.isHolding == obj then
				obj.firetimer = 36
				obj.seen = true
			end
			if obj.firetimer >= 36 then
				obj.fire = true
				if obj.firetimer > 40 then
					obj.firetimer = 40
				end
			elseif obj.firetimer <= 0 then
				obj.fire = false
				obj.firetimer = 0
			end

		--for _,object in pairs(mapcontent.turretlist) do
			if obj.fire then
				line(obj.x,obj.y,player.x,player.y,2)
				if t%12 == 0 then
					sfx(2,'A-4',15,0,12)
				end
				if t%10 <= 5 then
					obj.spval = 97
				else
					obj.spval = 65
				end
				obj.firetimer = obj.firetimer - 0.5
			end

			

		--end
	end
end

function addwithSign(num,add)
	if num < 0 then return num - add end
	if num >= 0 then return num + add end
end

function invert(num)
	if num > 0 then return -num 
	else return math.abs(num)
	end
end

function portalLogic()
		for _,sprite in pairs(mapcontent.entitylist) do
			sprite.dotilecollide = {true,true,true}
			if sprite.doportalcollide then
				
				--portalcolliders = collidePortal(sprite)

				--if not portalcolliders[1] then
				--	goto nextsprite
				--end
				if sprite.excludeportal or not sprite.draw then
					goto nextsprite
				end

				local ox=0 
				local oy=0
				if spriteoverlap(sprite.x+sprite.vx,sprite.y+sprite.vy,8,8,getPortalrect(orangeportal)) then
					sprite.x = blueportal.x
					sprite.y = blueportal.y
				elseif spriteoverlap(sprite.x+sprite.vx,sprite.y+sprite.vy,8,8,  getPortalrect(blueportal)) then
					if orangeportal.face==1 then ox=0 oy=0
					elseif orangeportal.face==2 then ox=0 oy=0	
					elseif orangeportal.face==3 then ox=0 oy=0
					else ox=0 oy=-4 end
					sprite.x = orangeportal.x
					sprite.y = orangeportal.y
				else
					goto nextsprite
				end
				
				local tx = sprite.vx
				local ty = sprite.vy
				
				sprite.doportalcollide = false

				if blueportal.face==orangeportal.face then --same side

					if blueportal.face == 3 or blueportal.face == 1 then --horiz (1-3)
						if blueportal.face==1 then 
							if sprite.vx==0 then sprite.vx=-2 end
						else
							if sprite.vx==0 then sprite.vx=2 end
						end
						sprite.vx = invert(sprite.vx)*1.2
					else  --vert (2-4)
						
						sprite.vy = invert(sprite.vy)*1.17
						sprite.dotilecollide = {false,false,true}
						--sprite.vy = invert(sprite.vy)*1.1
					end
				
				elseif blueportal.face == 2 or orangeportal.face == 2 then --up to horiz
					if blueportal.face == 1 or orangeportal.face == 1 then --west portal
						sprite.vy = math.abs(tx)
						sprite.vx = -ty*1.1
					elseif blueportal.face == 3 or orangeportal.face == 3 then
						sprite.vy = math.abs(tx)
						sprite.vx = ty*1.1
					end

				elseif blueportal.face == 4 or orangeportal.face == 4 then --down to horiz
					if ty==0 then ty=sprite.gravity*5 end
					if blueportal.face == 1 or orangeportal.face == 1 then  --west portal
						sprite.vx = math.abs(ty*1.2)
						sprite.vy = -math.abs(tx*1.1)
					elseif blueportal.face == 3 or orangeportal.face == 3 then
						sprite.vx = -math.abs(ty*1.2)
						sprite.vy = -math.abs(tx*1.1)
					end
				end
				::nextsprite::
			else

				if sprite.portalcollidelen >= 4 then
					sprite.doportalcollide = true
					sprite.portalcollidelen = 0
				else
					sprite.doportalcollide = false
					sprite.portalcollidelen = sprite.portalcollidelen+1
				end
			end
		end
end

function getmaptiles()
	return (maplist[maplist.current][1]-1)*30, (maplist[maplist.current][2]-1)*29,30,17,0,0
end



function drawFrame()
	--sync(0,0,false)
	--loadMap()
	
	vbank(0)
	poke(0x3FF8,15)
	cls(00)
	index = 01
	r=36
	g=41
	b=55	
	poke(0x03fc0 + index * 3, r)
  	poke(0x03fc0 + index * 3 + 1, g)
 	poke(0x03fc0 + index * 3 + 2, b)
	map(0,34,34,17,-math.abs(player.x/25),1,6)
	


	map(0,17,34,17,-math.abs(player.x/15),1,6)


	vbank(1)
	map(getmaptiles())
	

	
	print(player.x/25,1,64,2)
	--draw outline shiz
	local a,l = getAngleDistance(player,gmouse())
	--end of outline shiz
	print(math.deg(a),1,56,2)

	print("o "..tostring(orangeportal.face),9,1,2)
	print("b "..tostring(blueportal.face),9,8,2)



	for _,val in ipairs(renderorder) do
		for _,sprite in pairs(val) do
			draw(sprite)
			if sprite.type == "turret" then
				if sprite.seen  then
					spr(98,sprite.x,sprite.y-10, 00, 1)
				end
			end
		end
		
	end



	--for _,obj in pairs(objectlist) do
	--	outline(obj)
	--	draw(obj)
	--	
	--end
	--for _,sprite in pairs(entitylist) do
	drawUI()
	UIinteractable()
	
	
end



function BDR(scnline)
	if gamestate ~= "ingame" then
		vbank(0)
		if scnline % 5 == 0 then
			r=26-scnline/6
			g=28-scnline /6
			b=44-scnline /6
		end
		index=0
		index2=15
		poke(0x03fc0 + index * 3, r)
		poke(0x03fc0 + index * 3 + 1, g)
		poke(0x03fc0 + index * 3 + 2, b)


		
		poke(0x03fc0 + index2 * 3, r+7)
		poke(0x03fc0 + index2 * 3 + 1, g+7)
		poke(0x03fc0 + index2 * 3 + 2, b+7)

		vbank(1)
	else
		if scnline < 100 then
			vbank(0)
			index=1
			index2 = 15
			if scnline % 10 == 0 then
				r=39-scnline/3
				g=46-scnline/3
				b=54-scnline/3
			end
			if r<0 then r=0 end
			if g<0 then g=0 end
			if b<0 then b=0 end
			poke(0x03fc0 + index * 3, r)
			poke(0x03fc0 + index * 3 + 1, g)
			poke(0x03fc0 + index * 3 + 2, b)
	
			if scnline % 6 == 0 then
				rr=51-scnline/3
				gg=60-scnline/3
				bb=87-scnline/2
			end
			if rr<0 then rr=0 end
			if gg<0 then gg=0 end
			if bb<0 then bb=0 end
			poke(0x03fc0 + index2 * 3, rr)
			poke(0x03fc0 + index2 * 3 + 1, gg)
			poke(0x03fc0 + index2 * 3 + 2, bb)
	
	
			vbank(1)
	end
end
end

function collision()
	if orangeportal.draw and blueportal.draw then
		portalLogic() 
	else
		for _,sprite in pairs(mapcontent.entitylist) do
			sprite.doportalcollide = true
		end
	end

	collideTile()
end

function replacepixarea(sprite, spritereplacers, repstart, repend)
	--for x = 0,7,1 do
	--	for y = 0,7,1 do
	--		pix(x+1,y+1,pix(sprite.x+x+1,sprite.y+y+1))
	--	end
	--end
	
	--256

	--x = 0 - 7
	--y = mapped 0-7 per pixel
	--y in groups of 8

	--y = 8*16 = 256 line 0

	--THIS x AND Y OF SPRITE ARE CORRECT
	--Y value of sprite
	local by = sprite / 2
	--x pos
	local xm = sprite % 16

	print(xm.." "..by,36,9,2)
	for x = xm+repstart[1],xm+repend[1],1 do
		for y = by+repstart[2],by+repend[2],1 do
			print(x, 80, 9 ,2)
			--addr*2+x%8+by%8*8)
			--get mem address of pixel ^^
			local addr=0x4000+(x//8+y//8*16)*32 -- get sprite address	
			--prints pixel to top left!!!
			--pix(x,y,peek4(addr*2+x%8+by%8*8),36,8,2)
			poke4(addr*2+x%8+y%8*8,spritereplacers[y-by][x]) -- set sprite pixel
		end
	end
end
	


function mainmenu()

	

	iconanim = {-1.5,-1,-0.5,0,0.5,1,1.5}
	cls(00)
	scale = 2
	vbank(0)
	cls(00)
	map(0,17,34,17,-math.abs(t/2%240),1,6)
	map(0,17,34,17,-math.abs(t/2%240)+240,1,6)

	


	bg = {
		{176,56,2},
		{181,46,3},
		{191,26,4},
		{197,14,11},
	}
	for _,val in pairs(bg) do
	--176 to 232 (56)
		rect(val[1],0,val[2],140,val[3])
	end
	vbank(1)

	
	logomult = math.cos(math.rad((t%360)))
	menutiles.icon[331][2] = 1 + logomult
	menutiles.icon[347][2] = 2 + logomult
	menutiles.icon[363][2] = 3 + logomult
	--0.1*math.cos((t/2%60)//3.14)

	for _,tbl in pairs(menutiles) do
		if _ == "icon" then scale=3 else scale=2 end
		for pos,val in pairs(tbl) do
			spr(pos,(val[1]*(8*scale)),(val[2]*(8*scale)),00,scale)
		end
	end
	
	

		print("New Game", 16, 64, 10)
		print("Levels", 16, 72, 3)
		print("Options", 16, 80, 2)
		print("Exit :(", 16, 88, 15)

		if gamestate == "start" then
			Buttonanim(16,64, "New Game", 10,"ingame")
			music()
			return
		end
		if gamestate == "exitgame" then
			Buttonanim(16,88, "Exit :(", 15,"exit")
			return
		end
		--drawtextoutline("New Game",16,64,12)
		--print("New Game",16,64,10)
		--print("Levels",16,72,3)
		--print("Options",16,80,3)

		if Button(16,64,"New Game",10) and gmouse().left then --new game
			gamestate = "start"
			
		end

		if Button(16,72,"Levels",3) and gmouse().left then --Levels
			if useCooldown <= 0 then
				LvlMenu = not LvlMenu
				useCooldown = 5
			end

		end

		if Button(16,80,"Options",2) and gmouse().left then --new game
			print("e")
		end

		if Button(16,88,"Exit :(",15) and gmouse().left then --new game
			gamestate = "exitgame"
		end
		LevelsMenu()
		if useCooldown > 0 then
			useCooldown = useCooldown-1
		end
		
end


function Buttonanim(bx,by,text, clr, state)
	
	vbank(1)
	bh = 6
	bw = string.len(text)*5 + string.len(text)


	if not offset then offset = 1 end
	if offset > bw then
		gamestate = state
		return
	end

	print(text,bx,by,clr)
	rect(bx-6,by-2,offset,8,00)
	spr(274,bx-6+offset,by-2,00,1,1)
	spr(275,bx+bw-6,by-2,00,1,0)
	offset = offset + 3
	vbank(0)
end
function Button(bx,by,text,colour)
	bh = 6
	bw = string.len(text)*5 + string.len(text)
	aw=1
	ah=1
	ax = gmouse().x
	ay = gmouse().y

	local output = ax<bx+bw and bx<ax+aw and ay<by+bh and by<ay+ah

	if output then
		spr(274,bx-6,by-2,00,1,1)
		spr(275,bx+bw-6,by-2,00,1,0)
		drawtextoutline(text,bx,by,12)
	end
	print(text,bx,by,colour)
	
	return output
end

function LevelsMenu()

	if not LvlMenu then return end
	rect(88,48,64,80,15)
	rect(88,48,64,2,14)
	rect(90,65,60,61,14)

	print("Levels: ",92,55,12)
	for _,val in pairs(maplist) do
		if tonumber(_) then
			if Button(94,61 + (_*8),mapnames[_],4) and gmouse().left then
				maplist.current = _
				gamestate = "start"
			end
		end
	end
end

function TIC()
	
	if gamestate == "mainmenu" or gamestate == "start" then
		mainmenu()
	elseif gamestate == "ingame" then

		playerUpdate()
		gunUpdate()
		ObjectUpdate()
		TurretUpdate()

		collision()
		velocity()

		
		
		drawFrame()
	elseif gamestate == "exit" then
		exit()
	end
	
	if key(44) then
		exit()
	end
	
	t=t+1

	
end
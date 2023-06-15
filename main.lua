-- Version:1.25
local key = getSN();
local sever = 'https://autofbios.app/api'
function sleepWithToast(x,mess) -- nghỉ có hiện thông báo
	local timeslepp = x
	repeat 
		toast(mess.." "..timeslepp/1000);
		timeslepp = timeslepp - 1000
		usleep(1000000);
	until timeslepp <= 0
end
function sleep(x)
	usleep(x*1000);
end
function HTTPGet(InHeader,Link)
	local http = require('socket.http')
	local ltn12 = require("ltn12")
	local url = Link
	local resp = {}
	local body, code, respheaders, status = http.request{ 
		url = url,
		headers = InHeader,
		sink = ltn12.sink.table(resp)
		}

	if code ~= 200 then 
		toast("Error: "..(code or ''),5)
		sleep(2000);
		return "false"
	end
	log(table.concat(resp,"\n"))
	if resp then return table.concat(resp)
	else return "false"
	end
end
function ChangeIPvia3G() -- bật tắt chế độ máy bay
	io.popen("activator send switch-on.com.a3tweaks.switch.airplane-mode");
	sleepWithToast(3000,"Wait Changging Ip 3g ")
	io.popen("activator send switch-off.com.a3tweaks.switch.airplane-mode")
	sleepWithToast(4000,"Wait Changging Ip 3g ")
end
function check3g()
	f = assert(io.popen("curl api.viphpt.xyz/api/checkip.php"))
	ip = f:read("all")
	if (string.find(ip, ".") == nil and string.find(ip, ":") == nil) then
		io.popen("activator send switch-off.com.a3tweaks.switch.airplane-mode")
		repeat
			toast("Chờ internet ")
			f = assert(io.popen("curl api.viphpt.xyz/api/checkip.php"))
			ip = f:read("all")
			usleep(500000)
		until(string.find(ip, ".") ~= nil or string.find(ip, ":") ~= nil)
	end
	f = assert(io.popen("curl api.viphpt.xyz/api/checkip.php"))
	ip = f:read("all")
	if (string.find(ip, "HTML") ~= nil) then
		i = 1
		repeat
			io.popen("activator send switch-on.com.a3tweaks.switch.airplane-mode");
			usleep(2000000)
			io.popen("activator send switch-off.com.a3tweaks.switch.airplane-mode")
			usleep(2000000)
			f = assert(io.popen("curl api.viphpt.xyz/api/checkip.php"))
			ip = f:read("all")
			if (string.find(ip, ".") == nil and string.find(ip, ":") == nil) then
				io.popen("activator send switch-off.com.a3tweaks.switch.airplane-mode")
				repeat
					toast("Chờ internet ")
					f = assert(io.popen("curl api.viphpt.xyz/api/checkip.php"))
					ip = f:read("all")
					usleep(500000)
				until(string.find(ip, ".") ~= nil or string.find(ip, ":") ~= nil)
			end
			j = 1
			repeat
				toast("Chờ internet "..j)
				f = assert(io.popen("curl api.viphpt.xyz/api/checkip.php"))
				ip = f:read("all")
				if (string.find(ip, "HTML") == nil) then
					return
				end
				j = j + 1
				usleep(500000)
			until(j == 20)
			i = i + 1
		
			if (i == 4) then
				alert("KO co internet")
				stop()
			end
		until(string.find(ip, "HTML") == nil)
	end
end
------
function findButtonLike(time) -- tìm và nhấn nút like
	local timeOut = time
	repeat
	toast("Đang tìm nút LIKE "..timeOut)
	local result = findImage("/var/mobile/Library/AutoTouch/Scripts/facebook/img/findLIKE.PNG", 1,0.99,nil,false)
	
	if result[1] ~= nil then
		tap(result[1][1],result[1][2])
		usleep(1000000)
			sleepWithToast(2000,"Đã nhấn nút Like")
		break
	end
	if result[1] == nil then
			keoxuong(8000)
			findButtonLike(10)
			break
	end
	usleep(1000000);
	timeOut = timeOut - 1
	if timeOut == 0 then 
		break 
	end
	until 1==2
end
function writetxt(file, content, style, time, enter)
	f = io.open("/var/mobile/Library/AutoTouch/Scripts/facebook/"..file, style)
	if (enter == 1) then
		f:write(content, "\n");
	else
		f:write(content);
	end
	usleep(time);
	f:close();
	x = readtxt(file);
	if (x == 0) then
		f = io.open("/var/mobile/Library/AutoTouch/Scripts/facebook/"..file, style)
		if (enter == 1) then
			f:write(content, "\n");
		else
			f:write(content);
		end
		usleep(time);
		f:close();
	end
end
function writetxt2(file, content1, content2, style, time)
	f = io.open("/var/mobile/Library/AutoTouch/Scripts/facebook/"..file, style)
	f:write(content1, "\n");
	usleep(time);
	f:write(content2)
	f:close();
	x = readtxt(file)
	if (x == 0) then
		f = io.open("/var/mobile/Library/AutoTouch/Scripts/facebook/"..file, style)
		f:write(content1, "\n");
		usleep(time);
		f:write(content2)
		f:close();
	end
end
function readFile(path)
    local file = io.open(path,"r");
    if file then
        local _list = {};
        for l in file:lines() do
			l = l:gsub("\n", "");--remove xún dòng
            table.insert(_list,l)
        end
        file:close();
        return _list
    end
end
function splitString(inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end
function ReadFileWithSpecChar(path,specchar)
	local file = io.open(path,"r");
	if file then
		local _list = {};
		for l in file:lines() do
			table.insert(_list,splitString(l,specchar))
		end
		file:close();
		return _list
	end
end
function writeFile(path,text,mode)
    local file = io.open(path,mode);--a:append mode, 
    if file then
        file:write(text);
        file:close();
    end
end
function readFileString(file) -- đọc toàn bộ nội dung file txt
    local file = io.open("/var/mobile/Library/AutoTouch/Scripts/facebook/"..file,"rb");
    if file then
		local content = file:read "*a"
		file:close();
		return content
    end
end
function keolen(time);
	x = 400
	y = 700
	touchDown(6, x, y)
	usleep(20000)
	for i = 1, 50 do
		touchMove(6, x, y+i*10);
		usleep(time);
	end
	touchUp(6, x, y+60)
	usleep(1000000)
end
------
function readtxt(file); -- đọc txt theo dòng
	f = io.open("/var/mobile/Library/AutoTouch/Scripts/facebook/"..file, "r");
	local content1 = f:read("*line");
	local content2 = f:read("all");
	f:close()
	if (content1 == nil) then
		return 0
	else
		return content1, content2
	end
end
function tapimg(img, sl, time) -- tìm hình và click
	local img = findImage("/var/mobile/Library/AutoTouch/Scripts/facebook/img/"..img, sl, 0.99, nil)
	for i, v in pairs(img) do
		tap(v[1], v[2])
		usleep(time)
		return 1
	end
	return 0
end
function tap(x, y);
	touchDown(6, x, y);
	usleep(150000);
	touchUp(6, x, y);
	usleep(150000);
end
function keoxuong(time);
	x = 400
	y = 700
	touchDown(6, x, y)
	usleep(20000)
	for i = 1, 50 do
		touchMove(6, x, y-i*10);
		usleep(time);
	end
	touchUp(6, x, y-60)
	usleep(1000000)
	touchDown(6, x, y)
	touchUp(6, x, y)
	usleep(1000000)
end
function tapButtonSendCMT() -- click vào nút gửi bình luận
	tap(691, 852)
	return true
end
function doctb(sl)
	if (sl == 0) then return end
	for j = 0, sl do
		toast("Đang đọc "..j.." thông báo")
		openURL("fb://notifications")
		usleep(2000000)
		local result = findColor(15201279, 1, nil);
		for i, v in pairs(result) do
			tap(v[1], v[2]);
			usleep(3000000)
		end
	end
end
function CMT() -- cmt nội dung từ file txt
	local test1 = tapimg("binhluan.PNG", 1, 3000000)
			if (test1 == 1) then
				local text, cont = readFileString("binhluan.txt")
				--writetxt2("binhluan.txt", cont, text, "w", 1)
				inputText(text)
				usleep(1000000)
				tapButtonSendCMT()
				usleep(3000000)
				tap(66, 1280)
				usleep(2000000)
				keoxuong(8000)
				usleep(1000000)
			end
end
function luotnew(slvuot_newcotuongtac,sllike_newcotuongtac,slcmt_newcotuongtac,slchiase_newcotuongtac,noidungcmt_newcotuongtac)
	closeFacebook()
	usleep(1500000)
	openURL("fb://feed")
	usleep(2000000)
		toast("Tương tác Newsfeeds 📰",2);
	vuot, like, bl, cs = 0, 0, 0, 0
	if (vuot == slvuot_newcotuongtac) then return end
	tap(66, 1280)
	usleep(1000000)
	tap(66, 1280)
	usleep(1000000)
	keolen(2000)
	usleep(3000000)
	--tapimg("xnok.jpg", 1, 2000000)
	keolen(2000)
	usleep(3000000)
	tapimg("xnok.jpg", 1, 2000000)
	repeat
		local test1 = tapimg("ok.jpg", 1, 2000000)
		if (test1 == 1) then
			toast("Chưa login acc fb")
			--loginlai(matkhau, key2fa)
		end
		keoxuong(8000)
		usleep(1000000)
		if (like ~= sllike_newcotuongtac) then
			local test1 = tapimg("like.jpg", 1, 1000000)
			if (test1 == 1) then
				like = like + 1
				toast("Đã Like "..like.." / "..sllike_newcotuongtac,2)
			end
		end
		if (bl ~= slcmt_newcotuongtac) then
			local test1 = tapimg("binhluan.jpg", 1, 3000000)
			if (test1 == 1) then
				bl = bl + 1
				toast("Đã CMT "..bl.." / "..slcmt_newcotuongtac,2)
				--local text, cont = getNoiDungCMTweb(sever,key)
				--writetxt2("binhluan.txt", cont, text, "w", 1)
				inputText(noidungcmt_newcotuongtac)
					sleepWithToast(7000,"chờ nhấn nút gửi CMT")
				tap(687, 853)
				sleepWithToast(5000,"Đợi load")
				tap(66, 1280)
				usleep(2000000)
				keoxuong(8000)
				usleep(1000000)
			end
		end
		if (cs ~= slchiase_newcotuongtac) then
			local test1 = tapimg("chiase.jpg", 1, 2000000)
			if (test1 == 1) then
				cs = cs + 1
				toast("Đã Chia Sẻ "..cs.." / "..slchiase_newcotuongtac,2)
				tapimg("chiase2.jpg", 1, 3000000)
				
			end
		end
		vuot = vuot + 1
		toast("Đã Vuốt "..vuot.." / "..slvuot_newcotuongtac,2)
	until (vuot == slvuot_newcotuongtac)
end
function tuongtacIDPage(ID,slvuot, sllike,noidungcmt_tuongtacpage,tongsocmt_tuongtacpage,tongsodacmt_tuongtacpage,sttpage,slchiase,noidungchiase)
	openURL("fb://profile?id="..ID);
	sleepWithToast(7000,"chờ load Page ✅")
	tapimg("likepage.jpg", 1, 1000000)
	usleep(2000000)
	tapimg("likepage2.jpg", 1, 1000000)
	usleep(1000000)
	vuot, like, bl, chiase = 0, 0, 0, 0
	if (vuot == slvuot) then return end
	repeat
		toast("Tương Tác Page 📰 \n Đang Vuốt "..vuot.." / "..slvuot.."\n".."Like "..like.." / "..sllike,2);
		local test1 = tapimg("ok.jpg", 1, 2000000)
		if (test1 == 1) then
			toast("Chưa login acc fb")
			--loginlai(matkhau, key2fa)
		end
		keoxuong(9000)
		usleep(1000000)
		if (like ~= sllike) then
			local test1 = tapimg("likepostpage.jpg", 1, 1000000)
			if (test1 == 1) then
				like = like + 1
			end
		end
		if (chiase ~= slchiase) then
			local test1 = tapimg('buttonsharepageID.png',1,1000000)
			if (test1 == 1) then
				chiase = chiase + 1
				checkgroup(noidungchiase)
			end
		end
		if (tongsodacmt_tuongtacpage ~= tongsocmt_tuongtacpage) then
			slbl = 1
			if (bl ~= slbl) then
				local test1 = tapimg("cmtIDpage.png", 1, 3000000)
				if (test1 == 1) then
					bl = bl + 1
					--local text, cont = getNoiDungCMTweb(sever,key)
					--writetxt2("binhluan.txt", cont, text, "w", 1)
					inputText(noidungcmt_tuongtacpage)
					sleepWithToast(5000,"Đang lấy nội dung cmt từ sever")
					sleepWithToast(3000,"Bắt Đầu CMT")
					usleep(2000000)
					tapimg("sentcmt.jpg", 1, 1000000)
					sleepWithToast(5000,"Đợi load")
					usleep(2500000)
					local checkdisscmt = tapimg("dismisscmt.png",1,10000)
					if(checkdisscmt == 0) then 
						local body = request(sever.."/updatecmt.php?key="..key.."&sttpage="..sttpage) --update tong len sever
					end
					usleep(2000000)
					tapimg("backcmtgroup.jpg", 1, 2000000)
					usleep(2000000)
					keoxuong(8000)
					usleep(1000000)
				end
			end
		end
		vuot = vuot + 1
	until (vuot == slvuot)
end
function tapimglike(img, sl, time) -- tìm hình và click
    local img = findImage("/var/mobile/Library/AutoTouch/Scripts/facebook/img/"..img, sl, 0.99, nil)
    for i, v in pairs(img) do
        local myTable = { '1', '2', '3'}
        local rancamxuc = tonumber(myTable[ math.random( #myTable ) ])
        if (rancamxuc == 1) then 
        tap(v[1], v[2])
        usleep(100000)
        return 1
        elseif (rancamxuc == 2) then
            tapLove(v[1], v[2])
            return 1
        else
            tapCare(v[1], v[2])
            return 1
        end
    return 0
    end
end
function tapLove(x,y) -- click cảm xúc love
    
        touchDown(1,x, y);
        usleep(1000000)
            xlove = x + 90
            tap(xlove,y)
        usleep(500000)
        return 1
end
function tapCare(x,y) -- click cảm xúc thương thương
    touchDown(1,x, y);
        usleep(1000000)
            xlove = x + 180
            tap(xlove,y)
        usleep(500000)
        return 1
end	
function tuongtacID(ID,slvuot, sllike, slbl, slcs)
	openURL("fb://profile?id="..ID);
	sleepWithToast(7000,"chờ load nội dung của ID bài viết")
	vuot, like, bl, cs = 0, 0, 0, 0
	if (vuot == slvuot) then return end
	tapimg("xnok.jpg", 1, 2000000)
	usleep(3000000)
	tapimg("xnok.jpg", 1, 2000000)
	repeat
		local test1 = tapimg("ok.jpg", 1, 2000000)
		if (test1 == 1) then
			alert("Chưa login acc fb")
			--loginlai(matkhau, key2fa)
		end
		keoxuong(16000)
		usleep(1000000)
		if (like ~= sllike) then
			local test1 = tapimg("likepostid.jpg", 1, 1000000)
			if (test1 == 1) then
				like = like + 1
			end
		end
		if (bl ~= slbl) then
			local test1 = tapimg("cmtpostid.jpg", 1, 3000000)
			if (test1 == 1) then
				bl = bl + 1
				local text, cont = getNoiDungCMTweb(sever,key)
				--writetxt2("binhluan.txt", cont, text, "w", 1)
				inputText(text)
					sleepWithToast(5000,"chờ load nội dung CMT")
				tap(685,520)
				sleepWithToast(2000,"chờ nhấn nút gửi CMT")
				tapimg("dangcmtpostid.jpg", 1, 3000000)
				sleepWithToast(3000,"Đợi load")
				keolen(18000);
			end
		end
		if (cs ~= slcs) then
			local test1 = tapimg("sharepostid.jpg", 1, 2000000)
			if (test1 == 1) then
				cs = cs + 1
				tapimg("dangshare.jpg", 1, 3000000)
			end
		end
		vuot = vuot + 1
	until (vuot == slvuot)
end
function luotnewsGroup(slvuot, sllike, slbl, slcs,vitrialbum,ndcmt)
	closeFacebook()
	usleep(1200000)
	openURL("fb://groups");
	usleep(3200000)
		toast("Tương tác Group 👥",5);
	vuot, like, bl, cs = 0, 0, 0, 0
	if (vuot == slvuot) then return end
	keolen(2000)
	usleep(1000000)
	keolen(2000)
	usleep(3000000)
	repeat
		toast("Tương Tác Group 👥 \n Đang Vuốt "..vuot.." / "..slvuot.."\n".."Like "..like.." / "..sllike.."\n".."Comments "..bl.." / "..slbl.."\n".."Share "..cs.." / "..slcs,8);
		local test1 = tapimg("ok.jpg", 1, 2000000)
		if (test1 == 1) then
			alert("Chưa login acc fb")
			--loginlai(matkhau, key2fa)
		end
		keoxuong(8000)
		usleep(1000000)
		if (like ~= sllike) then
			local test1 = tapimg("like.jpg", 1, 1000000)
			if (test1 == 1) then
				like = like + 1
			end
		end
		if (bl ~= slbl) then
			local test1 = tapimg("binhluan.jpg", 1, 3000000)
			if (test1 == 1) then
				bl = bl + 1
				--local text, cont = getNoiDungCMTweb(sever,key)
				--writetxt2("binhluan.txt", cont, text, "w", 1)
				if (vitrialbum ~= 0) then
				cmthinhanh(vitrialbum)
				usleep(1000000)
				end
				inputText(ndcmt)
				sleepWithToast(7000,"Đang lấy nội dung cmt từ sever")
				sleepWithToast(3000,"Bắt Đầu CMT")
				usleep(2000000)
				tapimg("sentcmt.jpg", 1, 1000000)
				sleepWithToast(5000,"Đợi load")
				usleep(2500000)
				tapimg("dismisscmt.png",1,10000)
				usleep(2000000)
				tapimg("backcmtgroup.jpg", 1, 2000000)
				usleep(2000000)
				keoxuong(8000)
				usleep(1000000)
			end
		end
		if (cs ~= slcs) then
			local test1 = tapimg("chiase.jpg", 1, 2000000)
			if (test1 == 1) then
				cs = cs + 1
				tapimg("chiase2.jpg", 1, 3000000)
			end
		end
		vuot = vuot + 1
	until (vuot == slvuot)
end

function luotNewsKhongTuongTac(slvuot)
	closeFacebook()
	usleep(1200000)
	openURL("fb://feed");
	usleep(3200000)
		toast("Lướt Newsfeeds 📰",2);
	keolen(2000)
	usleep(1000000)
	keolen(2000)
	usleep(3000000)
	vuot = 0
	if (vuot == slvuot) then return end
	repeat
	keoxuong(10000)
	usleep(1000000)
	vuot = vuot + 1
	until (vuot == slvuot)
end

function request(url)
	local http = require("socket.http")
	i = 1
	repeat
		local body = http.request(url)
		i = i + 1
		if (body ~= nil) then return body end
	until (body ~= nil)
end
function waitcolor(...)
	usleep(500000)
	local tab = {...}
	local cont = tab[#tab - 1];
	local value = tab[#tab]
	local j = 1
	repeat
		local i = 1;
		repeat
			local x = tab[i]
			local y = tab[i+1]
			local color = tab[i+2]
			i = i + 3
			if (getColor(x, y) == color) then
				usleep(500000)
				return x, y
			end
		until(i == #tab - 1);
		j = j + 1
		if (j == cont) then
			return 0
		end
		usleep(500000)
	until(j == cont)
end
function LoginFB(uid, matkhau, key2fa, sever, key,sttacc)
	local listfull = uid.."|"..matkhau.."|"..key2fa
	local checklive = checkuid(uid)
	if (checklive == 1) then
		local a = checkFolderUIDBackup(uid)
			if (a == 1) then
				RestoreAcc(uid)
				usleep(1000000)
				openFacebook()
				sleepWithToast(2000,"Chờ load..")
				openURL("fb://profile");
				sleepWithToast(3000,"Kiểm Tra Nút Lưu TK..")
				tapimg("clickoksavepass.jpg",1,10000)
			else
				openFacebook()
				local test = tapimg("dangnhap2.jpg", 1, 1000000)
				if (test == 1) then
					tap(267, 541);
					usleep(1000000)
					tap(673, 329)
					usleep(1000000)
					inputText(uid)
					usleep(500000)
					tap(229, 417);
					usleep(500000)
					inputText(matkhau)
					usleep(500000)
					tap(270, 520);
					--x = waitcolor(35, 88, 1603570, 139, 90, 1603570, 355, 785, 31487, 382, 785, 31487, 30, 1)
					sleepWithToast(8000,"Chờ Load");
					local timeOut = 2
					repeat
					toast("Check Pass "..timeOut)
						local result = findImage("/var/mobile/Library/AutoTouch/Scripts/facebook/img/saipass.jpg", 1, 0.99, nil)
							if result[1] == nil then
										local img = findImage("/var/mobile/Library/AutoTouch/Scripts/facebook/img/ok3.jpg", 1, 0.99, nil)
									if (img ~= nil) then
										for i, v in pairs(img) do
									tap(v[1], v[2])
									usleep(2000000)
									local img = findImage("/var/mobile/Library/AutoTouch/Scripts/facebook/img/ma2fa.jpg", 1, 0.99, nil)
									for i, v in pairs(img) do
										tap(v[1], v[2])
										local otp2fa = Get2FA(key2fa)
										--tap(141,677)--tap ô 2fa
										usleep(300000)
										inputText(otp2fa);
										usleep(300000)
										tapimg("dangnhap3.jpg",1,10);
										sleepWithToast(6000,"Đăng Nhập Thành Công!")
										sleepWithToast(2000,"Chờ load..")
											openURL("fb://profile");
											sleepWithToast(3000,"Chờ click OK..")
											tapimg("clickoksavepass.jpg",1,10000)
											usleep(200000)
										end
									end
								end
								
							else
								closeFacebook()
								sttacc = sttacc + 1
								local body = request(sever.."/getlistacc.php?key="..key.."&action=getlist&update=SAIPASS&number="..sttacc)
									UpdateSttAcc(sever,key,sttacc)
								sleepWithToast(1000,"Tài khoản Sai Pass ❌");
							end
							usleep(1000000);
							timeOut = timeOut - 1
							if timeOut == 0 then 
								break 
							end
					until 1==2
				end	
			end
	end
	if (checklive == 0) then
			-- trương hợp check die acc
			function removeLineTable(T,num)
						table.remove(T,num);
						sleep(1000);
			end
				local ListAccFBnews = readFile("/private/var/mobile/Library/AutoTouch/Scripts/facebook/accFB.txt");
				writetxt("accDie.txt",listfull,"a",1,1)
				removeLineTable(ListAccFBnews,1);
				writeFileTable("/private/var/mobile/Library/AutoTouch/Scripts/facebook/accFB.txt",ListAccFBnews);
				sleepWithToast(3000,"Tài khoản Checkpiont ❌");
				return false	
	end
end
function checkProfileLogindone()
		openURL("fb://profile");
		usleep(3500000);
		local checkimg = checkImg("checkprofile.png")
		return checkimg
end
function checkImg(img)
	local timeOut = 2
	repeat
		local result = findImage("/var/mobile/Library/AutoTouch/Scripts/facebook/img/"..img, 1, 0.99, nil)
		if (result[1]) ~= nil then
			return 1
		else
			return 0
		end
		usleep(1000000);
		timeOut = timeOut - 1
		if timeOut == 0 then 
			break 
		end
	until 1==2
end
function KetBanGoiY(slguikb)
	closeFacebook()
	usleep(1000000);
	openFacebook2()
	usleep(3000000);
	tap(689,1293)--tap vào dấu 3 gạch
	usleep(2500000)
	tapimg("friends.png",1,1000000)
	usleep(3500000)
	addfr = 0
	::addfr::
	keoxuong(18000)
	if (addfr == slguikb) then return end
	repeat
	toast("Kết bạn gợi ý ➕👥 \n Đã Gửi "..addfr.." / "..slguikb,2);
	local test1 = tapimg("addfr.jpg", 1, 100)
			if (test1 == 1) then
				addfr = addfr + 1
				usleep(2000000)
				goto addfr
			end
	usleep(2000000)
	keolen(2000)
	addfr = addfr + 1
	until (addfr == slguikb)
end
function ChapNhanKetBan(slchapnhan)
	closeFacebook()
	usleep(1000000);
	openFacebook2()
	usleep(3000000);
	tap(689,1293)--tap vào dấu 3 gạch
	usleep(3500000)
	tapimg("friends.png",1,1000000)
	usleep(3500000)
	xacnhan = 0
	::access::
	if (xacnhan == slchapnhan) then return end
	repeat
	toast("Chấp Nhận Kết Bạn ➕👥 \n Đã Xác Nhận "..xacnhan.." / "..slchapnhan,2);
	local test1 = tapimg("confirmketban.jpg", 1, 100)
			if (test1 == 1) then
				xacnhan = xacnhan + 1
				usleep(2000000)
				goto access
			end
	usleep(2000000)
	keoxuong(20000)
	xacnhan = xacnhan + 1
	until (xacnhan == slchapnhan)
end
function writeFileTable(path,Table)
	os.remove(path);
	sleep(1000);
    local file = io.open(path,"w");--a:append mode, 
    if file then
        for _,l in ipairs(Table) do
            --table.insert(_list,l)
			file:write(l.."\n");
        end
        file:close();
	end
end
function exit()
    return stop();
end
function openFacebook()
	appRun("com.facebook.Facebook");
	toast("Đang mở App Facebook ✅",4)
	usleep(3000000)
end
function openFacebook2()
	appRun("com.facebook.Facebook");
end
function closeFacebook()
	appKill("com.facebook.Facebook");
end
function openAppsManager()
	appRun("com.tigisoftware.ADManager");
end
function closeAppsManager()
	appKill("com.tigisoftware.ADManager");
end
function getNoiDungCMTweb(sever, key)
	http = require("socket.http")
				local body = request(sever.."/cmt.php?key="..key);
					json = require("json");
					temp1 = json.decode(body)
					status = temp1["status"]
					if( status == "true") then
					noidung = temp1["noidung"]
					return noidung;
					else
					exit();
					end
end
function dirLookup(dir)
   local p = io.popen('find "'..dir..'" -type f')  --Open directory look for files, save data in p. By giving '-type f' as parameter, it returns all files.     
   for file in p:lines() do                         --Loop through all files
       toast(file,10)       
   end
end
function countFileInFolder(path)
   	local p = io.popen('find "'..path..'" -type f')
	local count = 0
   	for file in p:lines() do
		count = count + 1
   	end
	return count
end
function delFolder(path)
	os.remove(path)
end
function delFolderInRestore(uid)
	path = "/private/var/mobile/Media/Books/Managed/FB2023/"..uid
	os.remove(path)
end
function createNewFoler(path,name)
	require "lfs"
	lfs.mkdir(path.."/"..name)
end
function createNewFolerinBackup(name)
	require "lfs"
	path = "/private/var/mobile/Media/Books/Managed/FB2023"
	lfs.mkdir(path.."/"..name)
end
function moveFile(path,newpath)
	os.rename(path, newpath)
end
function moveAllFile(path,newpath)
   local p = io.popen('find "'..path..'" -type f')    
   for file in p:lines() do                     
      -- alert(file);
		local fiilename = get_file_name(file)
		moveFile(file,newpath.."/"..fiilename)
   end
end
function delAllFileInBackup()
	path = "/private/var/mobile/Library/ADManager"
	local p = io.popen('find "'..path..'" -type f')    
   	for file in p:lines() do                     
      -- alert(file);
		local fiilename = get_file_name(file)
		os.remove(file)
	end
end
function moveAllFileBackUp(uid)
	path = "/var/mobile/Library/ADManager/"
	newpath = "/var/mobile/Media/Books/Managed/FB2023/"..uid
   local p = io.popen('find "'..path..'" -type f')    
   for file in p:lines() do                     
      -- alert(file);
		local fiilename = get_file_name(file)
		moveFile(file,newpath.."/"..fiilename)
   end
end
function moveAllFileRestore(uid)
	path = "/var/mobile/Media/Books/Managed/FB2023/"..uid
	newpath = "/var/mobile/Library/ADManager/"
	local p = io.popen('find "'..path..'" -type f')    
   for file in p:lines() do                     
      -- alert(file);
		local fiilename = get_file_name(file)
		moveFile(file,newpath.."/"..fiilename)
   end
end
function get_file_name(file)
      return file:match("^.+/(.+)$")
end
function checkFolderUIDBackup(uid)
	path = "/var/mobile/Media/Books/Managed/FB2023/"..uid
	require "lfs"
  if (lfs.attributes(path, "mode") == "directory") then
    return 1
  end
  return 0
end
function removeALlFileInFolder(path)
	local p = io.popen('find "'..path..'" -type f')    
   	for file in p:lines() do                     
      -- alert(file);
		local fiilename = get_file_name(file)
		delFolder(file)
   	end
end
function exec(cmd)
	local p = io.popen(cmd)
	local result = ''
	for file in p:lines() do
		if result == '' then
			result = file
		else
			result = result .. "\n" .. file
		end
	end
	return result
end
function delFolderPro(path)
	io.popen("rm -rf "..path)
end
function delFolderBackup()
	delFolderPro("/private/var/mobile/FB2023/tmp")
	delFolderPro("/private/var/mobile/FB2023/Documents")
	delFolderPro("/private/var/mobile/FB2023/Library/app_compactdisk")
	delFolderPro("/private/var/mobile/FB2023/Library/'Application Support'")
	delFolderPro("/private/var/mobile/FB2023/Library/Caches")
	delFolderPro("/private/var/mobile/FB2023/Library/Cookies")
	delFolderPro("/private/var/mobile/FB2023/Library/fb_persisted_counter_store_file_cache.sessionless.1")
	delFolderPro("/private/var/mobile/FB2023/Library/FBAutoupdater")
	delFolderPro("/private/var/mobile/FB2023/Library/Preferences")
	delFolderPro("/private/var/mobile/FB2023/Library/SyncedPreferences")
	delFolderPro("/private/var/mobile/FB2023/Library/WebKit")
end
function BackUpAcc(uid)
	toast("Đang Backup Tài Khoản",5)
	closeFacebook()
	closeAppsManager()
	usleep(1500000)
	delFolderBackup()
	usleep(1500000)
	openAppsManager()
	usleep(4000000)
	tapimg("fbbackup.png",1,1000000)
	keoxuong(2000)
	usleep(1000000)
	tapimg("clickbackup.png",1,1000000)
	usleep(1000000)
	tap(386,1132) --click chử backup facebook data
	usleep(3000000)
	createNewFolerinBackup(uid)
	usleep(1000000)
	moveAllFileBackUp(uid)
	usleep(1000000)
	tapimg("wipe.png",1,1000000)
	usleep(1000000)
	tap(386,1132) 
	usleep(2000000)
	closeAppsManager()
end
function RestoreAcc(uid)
	toast("Đang Restore Tài Khoản",5)
	closeAppsManager()
	moveAllFileRestore(uid)
	usleep(1000000)
	delFolderInRestore(uid)
	usleep(1000000)
	openAppsManager()
	sleepWithToast(3000,"Đang chờ ADM Load")
    usleep(1000000);
	tapimg("fbbackup.png",1,1000000)
	keoxuong(2000)
	usleep(1000000)
	tapimg("restorebackup.png",1,1000000)
	usleep(1000000)
	tap(385,1159)
	usleep(3000000)
	delAllFileInBackup()
	usleep(1000000)
	closeAppsManager()
end
function checkuid(uid)
	repeat
		https = require("ssl.https")
		body, code, headers, status = https.request('https://graph.facebook.com/'..uid..'/picture')
		if (body == nil or headers == nil) then
			io.popen("activator send switch-on.com.a3tweaks.switch.airplane-mode");
			usleep(2000000)
			io.popen("activator send switch-off.com.a3tweaks.switch.airplane-mode")
			usleep(4000000)
		end
	until (body ~= nil or headers ~= nil)
	test = headers["content-type"]
	if (test == "image/jpeg") then
		return 1
	else
		return 0
	end
end
function removeLineTable(T,num)
	table.remove(T,num);
	sleep(1000);
end
function checkfile(file)
	local f = io.open(currentPath().."/"..file, "r")
	local a = f:read("all")
	f:close()
	local f = io.open(currentPath().."/"..file, "r")
	b = f:read("line")
	if (b == nil) then return 0 end
	repeat
		c = f:read("all")
	until(#b + #c == #a - 1 or #b + #c == #a)
	f:close()
	repeat
		local f = io.open(currentPath().."/"..file, "w")
		f:write(c)
		f:close()
		local f = io.open(currentPath().."/"..file, "r")
		local a = f:read("all")
		f:close()
	until(#a == #c)
	return 1
end

function getTotalFromServer(server, key)
	local json = require "json"
	local total = 0 -- Giá trị mặc định
	
	while true do
		local getTotal = HTTPGet({ContentType = "application/json"}, server .. "/getstatus.php?action=NONE&key=" .. key)
		
		if getTotal ~= nil then
			local decodedData = json.decode(getTotal)
			
			if type(decodedData) == "table" and decodedData["total"] ~= nil then
				total = tonumber(decodedData["total"])
				return total
			else
				toast("Lỗi lấy thông tin từ máy chủ! Reconnect", 1)
			end
		end
		
		-- Đặt thời gian chờ trước khi thử kết nối lại
		sleep(1)
	end
end
function Get2FA(key2fa)
	Get2fa = HTTPGet({ContentType = "application/json"},"https://muaclonefb.com/get-2fa-api/"..key2fa)
	if Get2fa ~= nil then
		local json = require"json"
		otp2fa = json.decode(Get2fa)["token"]
		return tostring(otp2fa)
	end
end
function upDateStatusSLEEPFromSever(sever,key)
	Getstatus = HTTPGet({ContentType = "application/json"},sever.."/getstatus.php?action=SLEEP&key="..key)
	if Getstatus ~= nil then
			local json = require"json"
			status = json.decode(Getstatus)["status"]
			return status
		end
end
function GetSTTAcc(sever,key)
	::back::
	GetSTT = HTTPGet({ContentType = "application/json"},sever.."/sttacc.php?key="..key.."&action=GET&sttacc=1")
		if GetSTT ~= nil then
			local json = require"json"
			local decodedJson = json.decode(GetSTT)
			if not decodedJson then
				   toast("Lỗi JSON")
				   goto back
				else
			 local  sttacc = json.decode(GetSTT)["sttacc"]
				if not sttacc then
    				sleepWithToast(1000,"Lổi Connect Server Chờ KN lại")
    				goto back
    			else
    				return tonumber(sttacc)
    			end
    		end
	elseif (GetSTT == false) then
		goto back
	end
end
function UpdateSttAcc(sever,key,sttacc)
	UPdateSTT = HTTPGet({ContentType = "application/json"},sever.."/sttacc.php?key="..key.."&action=UPDATE&sttacc="..sttacc)
		if UPdateSTT ~= nil then
			local json = require"json"
			status = json.decode(UPdateSTT)["status"]
			return status
		end
end
function GetListAcc(sever,key,sttacc)
	GetListAcc = HTTPGet({ContentType = "application/json"},sever.."/getlistacc.php?key="..key.."&action=getlist&update=NONE&number="..sttacc)
		if GetListAcc ~= nil then
			local json = require"json"
			account = json.decode(GetListAcc)["account"]
			return account
		end
end
function getStatusFromSever(sever,key)
	::back::
	local Getstatus = HTTPGet({ContentType = "application/json"},sever.."/getstatus.php?action=NONE&key="..key)
	if Getstatus ~= nil then
			local json = require"json"
			local decodedJson = json.decode(Getstatus)
			if not decodedJson then
				   toast("Lỗi JSON")
				   goto back
				else
			 local  status = json.decode(Getstatus)["status"]
				if not status then
    				sleepWithToast(1000,"Lổi Connect Server Chờ KN lại")
    				goto back
    			else
    				return status
    			end
    		end
	elseif (Getstatus == false) then
		goto back
	end
end
function updateTrangThaiTuongTac(sever,key,trangthai)
 local body = request(sever.."/updatetuongtac.php?key="..key.."&tuongtac="..trangthai)
end
function tuongtac(sever,key)
		Gettuongtac = HTTPGet({ContentType = "application/json"},sever.."/tuongtac.php?key="..key)
			if Gettuongtac ~= nil then
			local json = require"json"
		
			--[[ tương tác newf--]]
				slvuot_newcotuongtac = tonumber(json.decode(Gettuongtac)["slvuot_newcotuongtac"])
				sllike_newcotuongtac = tonumber(json.decode(Gettuongtac)["sllike_newcotuongtac"])
				slcmt_newcotuongtac = tonumber(json.decode(Gettuongtac)["slcmt_newcotuongtac"])
				slchiase_newcotuongtac = tonumber(json.decode(Gettuongtac)["slchiase_newcotuongtac"])
				noidungcmt_newcotuongtac = json.decode(Gettuongtac)["noidungcmt_newcotuongtac"]
				--[[ tương tác Group--]]
				slvuot_ttgroup = tonumber(json.decode(Gettuongtac)["slvuot_ttgroup"])
				sllike_ttgroup = tonumber(json.decode(Gettuongtac)["sllike_ttgroup"])
				slcmt_ttgroup = tonumber(json.decode(Gettuongtac)["slcmt_ttgroup"])
				slchiase_ttgroup = tonumber(json.decode(Gettuongtac)["slchiase_ttgroup"])
				noidungcmt_ttgroup = json.decode(Gettuongtac)["noidungcmt_ttgroup"]
				idalbum = tonumber(json.decode(Gettuongtac)["idalbum"])
				--[[đọc thông báo--]]
				sldocthongbao = tonumber(json.decode(Gettuongtac)["sldocthongbao"])
				--[[chấp nhận kết bạn--]]
				slchapnhankb = tonumber(json.decode(Gettuongtac)["slchapnhankb"])
				--[[tham gia group--]]
				slthamgiagroup = tonumber(json.decode(Gettuongtac)["slthamgiagroup"])
				tukhoathamgiagroup = json.decode(Gettuongtac)["tukhoathamgiagroup"]
				--[[gửi kết bạn--]]
				slguiketban = tonumber(json.decode(Gettuongtac)["slguiketban"])
				--[[mời bạn bè vào gr--]]
				idgroupmoibanbe = tonumber(json.decode(Gettuongtac)["idgroupmoibanbe"])
				slmoibanbethamgiagroup = tonumber(json.decode(Gettuongtac)["slmoibanbethamgiagroup"])
				--[[tương tác page--]]
				uidpage_tuongtacpage = tonumber(json.decode(Gettuongtac)["uidpage_tuongtacpage"])
				vuot_tuongtacpage = tonumber(json.decode(Gettuongtac)["vuot_tuongtacpage"])
				like_tuongtacpage = tonumber(json.decode(Gettuongtac)["like_tuongtacpage"])
				share_tuongtacpage = tonumber(json.decode(Gettuongtac)["share_tuongtacpage"])
				tongsocmt_tuongtacpage = tonumber(json.decode(Gettuongtac)["tongsocmt_tuongtacpage"])
				tongsodacmt_tuongtacpage = tonumber(json.decode(Gettuongtac)["tongsodacmt_tuongtacpage"])
				noidungcmt_tuongtacpage = json.decode(Gettuongtac)["noidungcmt_tuongtacpage"]
				--[[tương tác page2--]]
				--[[uidpage_tuongtacpage2 = tonumber(json.decode(Gettuongtac)["uidpage_tuongtacpage2"])
				vuot_tuongtacpage2 = tonumber(json.decode(Gettuongtac)["vuot_tuongtacpage2"])
				like_tuongtacpage2 = tonumber(json.decode(Gettuongtac)["like_tuongtacpage2"])
				tongsocmt_tuongtacpage2 = tonumber(json.decode(Gettuongtac)["tongsocmt_tuongtacpage2"])
				tongsodacmt_tuongtacpage2 = tonumber(json.decode(Gettuongtac)["tongsodacmt_tuongtacpage2"])
				noidungcmt_tuongtacpage2 = json.decode(Gettuongtac)["noidungcmt_tuongtacpage2"]--]]
				--[[lướt news không tt--]]
				slluotNewsKhongTuongTac = tonumber(json.decode(Gettuongtac)["luotNewsKhongTuongTac"])

					if (slvuot_newcotuongtac ~= 0) then
						updateTrangThaiTuongTac(sever,key,"Lướt_Newsfeeds")
						luotnew(slvuot_newcotuongtac,sllike_newcotuongtac,slcmt_newcotuongtac,slchiase_newcotuongtac,noidungcmt_newcotuongtac)
					end
					if(sldocthongbao ~= 0) then
						updateTrangThaiTuongTac(sever,key,"Đọc_Thông_Báo")
						doctb(sldocthongbao)
					end
					if (slchapnhankb ~= 0) then
						updateTrangThaiTuongTac(sever,key,"Chấp_nhận_kết_bạn")
						ChapNhanKetBan(slchapnhankb)
					end
					if (slvuot_ttgroup ~= 0) then
						updateTrangThaiTuongTac(sever,key,"Lướt_Newsfeeds_Group")
						luotnewsGroup(slvuot_ttgroup,sllike_ttgroup,slcmt_ttgroup,slchiase_ttgroup,idalbum,noidungcmt_ttgroup)	
					end						
					if (luotNewsKhongTuongTac ~= 0) then
						updateTrangThaiTuongTac(sever,key,"Lướt_Newsfeeds_Không_TT")	
						luotNewsKhongTuongTac(slluotNewsKhongTuongTac)
					end
					if (slguiketban ~= 0) then 
						updateTrangThaiTuongTac(sever,key,"Kết_Bạn_Gợi_Ý")
						KetBanGoiY(slguiketban)
					end
					if (uidpage_tuongtacpage ~= 0) then 
						updateTrangThaiTuongTac(sever,key,"Tương_Tác_Page_ID_1")
						tuongtacIDPage(uidpage_tuongtacpage,vuot_tuongtacpage,like_tuongtacpage,noidungcmt_tuongtacpage,tongsocmt_tuongtacpage,tongsodacmt_tuongtacpage,1,share_tuongtacpage,"Xin Phép Ad Duyệt Bài Ạ ☺")
					end
					--[[if (uidpage_tuongtacpage2 ~= 0) then 
						updateTrangThaiTuongTac(sever,key,"Tương_Tác_Page_ID_2")
						tuongtacIDPage(uidpage_tuongtacpage2,vuot_tuongtacpage2,like_tuongtacpage2,noidungcmt_tuongtacpage2,tongsocmt_tuongtacpage2,tongsodacmt_tuongtacpage2,2)
					end--]]
					if (slthamgiagroup ~= 0) then 
						updateTrangThaiTuongTac(sever,key,"Tham_Gia_Group")
						JoinGroupByKeyword(slthamgiagroup,tukhoathamgiagroup)
					end
					--[[if (idgroupmoibanbe ~= 0) then 
						inviteGroup(idgroupmoibanbe,slmoibanbethamgiagroup)
					end--]]
						
				end
			
			
end

function JoinGroupByKeyword(sl,keyword)
	local timeOut = 7
	closeFacebook()
	usleep(1000000)
	openURL("fb://feed");
	usleep(2800000)
	tapimg("findkeyword.jpg",1,1000) -- tap img search
	usleep(2000000)
	inputText(keyword)
	usleep(2000000)
	tap(650,1292) -- tap button search
	usleep(1000000)
	tapimg("groupfind.jpg",1,1000) -- tap tab group
	usleep(2000000)
	sldathamgia = 0
	repeat
		if(sl < sldathamgia) then return end
				timeOut = timeOut - 1
				usleep(800000);
				if timeOut == 0 then 
				break 
				end
			toast("Đã tham gia "..sldathamgia.."/"..sl.." Group")
			keoxuong(15000)
			if (sldathamgia ~= sl) then
			local test1 = tapimg("buttonjoingroup.png",1,1000000);
			usleep(2000000)
			if (test1 == 1) then
				usleep(200000)
				if(sl == sldathamgia) then return end
				local checkAnswer = checkImg("answerGroup.png")
				if (checkAnswer == 1) then
					toast("Đang trả lời câu hỏi")
					local checkhinhtron = checkImg("hinhtronjoingroup.png")
					if (checkhinhtron == 1) then
						tapimg("hinhtronjoingroup.png",1,1000)
						keoxuong(32000)
					end
					local checkhinhvuong = checkImg("hinhvuongjoingroup.png")
					if (checkhinhvuong == 1) then
						tapimg("hinhvuongjoingroup.png",1,1000)
						keoxuong(30000)
					
					end
					local checkcautraloi = checkImg("vietcautraloivaonhom.png")
					if (checkcautraloi == 1) then
						tapimg("vietcautraloivaonhom.png",1,1000)
						inputText("Oke Admin")
						keoxuong(30000)
					end
				tapimg("submitjoingroup.png",1,1000)
				sldathamgia = sldathamgia + 1
				usleep(1000000)	
				end
				sldathamgia = sldathamgia + 1
				usleep(1000000)		
			end
		end
	until (sldathamgia > sl)

end
function inviteGroup(idgroup,sl)
	closeFacebook()
	usleep(1000000)
	openURL("fb://profile?id="..idgroup);
	usleep(5000000)
	tapimg("buttonjoingroup2.png",1,1000)
	usleep(2000000)
	 local checkInvite = tapimg("invitegroup.png",1,10000)
	usleep(6000000)
	sldamoi = 0 
	if(sl == sldamoi) then return end
	repeat
		::back::
		toast("Đã mời "..sldamoi.."/"..sl.." bạn")
		--keoxuong(18000)
			if (sldamoi ~= sl) then
			local test1 = tapimg("inviteg.png",1,100);
			if (test1 == 1) then
				sldamoi = sldamoi +1
				usleep(1500000)
				goto back
			else
				keoxuong(18000)
			end
		end
	until (sldamoi == sl)
	
end
function xoaram()
	--[[tap home 2--]]
	keyDown(KEY_TYPE.HOME_BUTTON);
	usleep(95818.62);
	keyUp(KEY_TYPE.HOME_BUTTON);
	usleep(112971.33);

	keyDown(KEY_TYPE.HOME_BUTTON);
	usleep(80915.04);
	keyUp(KEY_TYPE.HOME_BUTTON);
	usleep(269345.67);
	keyUp(KEY_TYPE.HOME_BUTTON);
	usleep(1426492.71);
--[[check có chạy ngầm không--]]
	repeat
	local checkcall = checkImg("call.png")
	if (checkcall == 0) then
		keoxuong(1000);
	else
		break;
	end
	until (1==2)
end
function cmthinhanh(namealbum)
	usleep(1000000)
	tapimg("cameracmt.png",1,1000);
	usleep(2000000)
	tapimg("tapheretochange.png",1,1000);
	usleep(2000000)
	if (namealbum == 1) then 
		tapimg("1a.png",1,100000);
	end
	if (namealbum == 2) then 
		tapimg("2b.png",1,100000);
	end
	if (namealbum == 3) then 
		tapimg("3c.png",1,100000);
	end
	usleep(2000000);
	repeat
	local checktap = 0
	::unback::
	if(checktap == 2) then break end
	taprandhinhanh()
	usleep(1000000)
	local a = tapimg("donealbum.png",1,1000)
	if(a == 0) then 
		checktap = checktap + 1
		goto unback
	end
	usleep(1000000)
	until (a == 1)
end
function taprandhinhanh()
  local x = math.random(12,673)
  local y = math.random(220,1270)
  tap(x,y)
end
 function checkColorGroup(x,y)
 	local a = getColor(x,y)
 	if (a == 16777215) then
 		return 0
 	else
 		return 1
 	end
 end
function InputTextDelay(a)
	for c in a:gmatch(".[\128-\191]*") do 
	    inputText(c)
	    usleep(40000)
	end
end
function FindGroup(toadox1,toadoy1,toadox2,toadoy2)
	local myTable = { '410', '590', '680','770','860'}
	local rancamxuc = tonumber(myTable[ math.random( #myTable ) ])
	local startX = tonumber(toadox1)
	local startY = tonumber(toadoy1) + 50
	local endX = tonumber(toadox2) 
	local endY = tonumber(toadoy2)
	for x = startX, endX do
	  for y = startY, endY do
	    -- Lấy mã màu tại tọa độ (x, y)
	    local color = getColor(x, y)
	    if color ~= 16777215 and color ~= 13731705 then
	      toast("Tìm thấy tọa độ khác: (" .. x .. ", " .. y .. ")",1)
	      return x.."|"..y
	    end
	  end
	end
end
function FindToaDoIMG(img) -- tìm hình và click
	local img = findImage("/var/mobile/Library/AutoTouch/Scripts/facebook/img/"..img, 1, 0.99, nil)
	for i, v in pairs(img) do
		--tap(v[1], v[2])
		return v[1].."|"..v[2]
	end
end
function checkgroup(noidungchiase)
	local myTable = { 'Xin phép admin ạ ☺', 'Cảm ơn admin duyệt bài ạ <3', 'Đều trị mụn hiệu quả :3','Xin phép cả nhà cùng xem cách trị mụn hiệu quả ạ ☺'}
	local rannoidungchiase = tostring(myTable[ math.random( #myTable ) ])
	--16777215 mã màu rổng không có group
	--tapimg('buttonsharepageID.png',1,100000)
	usleep(1000000)
	tapimg('buttonsharetoagroup.png',1,10000)
	usleep(2000000)
	sleepWithToast(1500,"Đang Get List Group")
	local checkGroup = getColor(49,870);

		if (checkGroup ~= 16777215) then
			local rand = math.random(0,2)
			for i=1,rand do
				keoxuong(16000)
			end
			local solancheck = 0
			local toadofindgroup = FindToaDoIMG("findgrshare.png")
			local toadochuQ = FindToaDoIMG("q_group.png")
			local toadochuQx2
			local toadochuQy2
			if (toadochuQ ~= nil) then 
				local b = splitString(toadochuQ,"|")
				 toadochuQx2 = tonumber(b[1]) + 15
				 toadochuQy2 = tonumber(b[2]) + 40
			else
			 toadochuQx2 = 950
			 toadochuQy2 = 950
			end	
			local a = splitString(toadofindgroup,"|")
			toadokinhx1 = tonumber(a[1]) + 15
			toadokinhy1 = tonumber(a[2]) + 40
			::back::
			local findgroup = FindGroup(toadokinhx1,toadokinhy1,toadochuQx2,toadochuQy2)
			usleep(500000)
			if (solancheck > 2) then 
				tap(49,870)
				usleep(1500000)
				tapimg('saygroup.png',1,100000)
					usleep(1500000)
					InputTextDelay(rannoidungchiase)
					usleep(100000)
					tapimg('shareIDnow.png',1,10000)
					usleep(3500000)
					return
			end
			local toadotapgroup =  splitString(findgroup,"|")
			if toadotapgroup ~= nil then
			tap(toadotapgroup[1],toadotapgroup[2])
			else
			toast("không find được quay về tọa độ mặt định",1)	
			tap(49,897)
			end
				usleep(2000000)
				local checktapgroupok = checkImg("shareIDnow.png")
				if(checktapgroupok == 1) then
					tapimg('saygroup.png',1,100000)
					usleep(1500000)
					InputTextDelay(rannoidungchiase)
					usleep(100000)
					tapimg('shareIDnow.png',1,10000)
					usleep(3500000)
				else
					toast("Tọa độ click không select được Gr",1)
					solancheck = solancheck + 1
					tapimg('buttonsharetoagroup.png',1,10000)
					usleep(2000000)
					goto back
				end
	else
				tapimg('backsharegroup.png',1,100000)	
				usleep(1000000)
				InputTextDelay(noidungchiase)
				usleep(100000)
				tapimg('shareIDnow.png',1,10000)
				usleep(3500000)
	end
end
--[[tapimg("join.png",1,10000)
stop()--]]
--[[tuongtacIDPage(117540492278654,10, 1,"HIHI",1,1,2,1,"<3 <3 <3")
stop()
local a =  getColor(49,673)

alert(a)
stop()--]]--]]
--[[local a = getColor(50,812)
alert (a)--]]
--- Kiểm tra dừng tools --
::startcheckstop2::
sttcheck = 0
::startcheckstop::
local isStop = ""
	isStop = tostring(getStatusFromSever(sever,key))
	if (isStop == "SLEEP") then
	sleepWithToast(2000,"Stop Tools 🛑")
	return
	elseif(isStop =="RUN") then
		toast("▶️")
	elseif(isStop == "RUNNING") then 
		toast("⏩")
	else
		sttcheck = sttcheck + 1
		sleepWithToast(3000,"Lổi không thể connect sever lần "..sttcheck)
			if(sttcheck == 3) then 
				ChangeIPvia3G()
				usleep(1000000)
				check3g()
				goto startcheckstop2
			end
		goto startcheckstop
	end
--- END Kiểm tra dừng tools --
::hihi::
local sttacc =  GetSTTAcc(sever,key)
local totalacc = getTotalFromServer(sever,key)
tol = totalacc + 1
if(sttacc < tol) then
							check3g()
							sleepWithToast(1500,"Đang tương tác "..sttacc.."/"..totalacc.." Acc ✅")
									GetListAcc = HTTPGet({ContentType = "application/json"},sever.."/getlistacc.php?key="..key.."&action=getlist&update=NONE&number="..sttacc)
									if GetListAcc ~= nil then
										local json = require"json"
										 account = tostring(json.decode(GetListAcc)["account"])
									end
									local ChuoiSauKhiTach = splitString(account,"|")
									 local uid = ChuoiSauKhiTach[1]
										sleepWithToast(1000,"Đang check Live : "..uid.." ☑️")
											--- Kiểm tra dừng tools --
												::startcheckstop21::
												sttcheck1 = 0
												::startcheckstop1::
												local isStop = ""
													isStop = tostring(getStatusFromSever(sever,key))
													if (isStop == "SLEEP") then
													sleepWithToast(2000,"Stop Tools 🛑")
													return
													elseif(isStop =="RUN") then
														toast("▶️")
													elseif(isStop == "RUNNING") then 
														toast("⏩")
													else
														sttcheck1 = sttcheck1 + 1
														sleepWithToast(3000,"Lổi không thể connect sever lần "..sttcheck1)
															if(sttcheck1 == 3) then 
																ChangeIPvia3G()
																usleep(1000000)
																check3g()
																goto startcheckstop21
															end
														goto startcheckstop1
													end
												--- END Kiểm tra dừng tools --
									local checkliveuid = checkuid(uid)
									 if (checkliveuid == 1) then
									 local body = request(sever.."/getlistacc.php?key="..key.."&action=getlist&update=LIVE&number="..sttacc)
									sleepWithToast(1000,"Tài Khoản Live : "..uid.." ✅")
											--- Kiểm tra dừng tools --
											::startcheckstop22::
											sttcheck2 = 0
											::startcheckstop2::
											local isStop = ""
												isStop = tostring(getStatusFromSever(sever,key))
												if (isStop == "SLEEP") then
												sleepWithToast(2000,"Stop Tools 🛑")
												return
												elseif(isStop =="RUN") then
													toast("▶️")
												elseif(isStop == "RUNNING") then 
													toast("⏩")
												else
													sttcheck2 = sttcheck2 + 1
													sleepWithToast(3000,"Lổi không thể connect sever lần "..sttcheck2)
														if(sttcheck2 == 3) then 
															ChangeIPvia3G()
															usleep(1000000)
															check3g()
															goto startcheckstop22
														end
													goto startcheckstop2
												end
											--- END Kiểm tra dừng tools --
											usleep(10000)
									xoaram()
									ChangeIPvia3G()
									check3g()
											--- Kiểm tra dừng tools --
											::startcheckstop23::
											sttcheck3 = 0
											::startcheckstop3::
											local isStop = ""
												isStop = tostring(getStatusFromSever(sever,key))
												if (isStop == "SLEEP") then
												sleepWithToast(2000,"Stop Tools 🛑")
												return
												elseif(isStop =="RUN") then
													toast("▶️")
												elseif(isStop == "RUNNING") then 
													toast("⏩")
												else
													sttcheck3 = sttcheck3 + 1
													sleepWithToast(3000,"Lổi không thể connect sever lần "..sttcheck3)
														if(sttcheck3 == 3) then 
															ChangeIPvia3G()
															usleep(1000000)
															check3g()
															goto startcheckstop23
														end
													goto startcheckstop3
												end
											--- END Kiểm tra dừng tools --
											updateTrangThaiTuongTac(sever,key,"Login_FB")--
									LoginFB(ChuoiSauKhiTach[1],ChuoiSauKhiTach[2],ChuoiSauKhiTach[3],sever,key,sttacc);
											--- Kiểm tra dừng tools --
											::startcheckstop24::
											sttcheck4 = 0
											::startcheckstop4::
											local isStop = ""
												isStop = tostring(getStatusFromSever(sever,key))
												if (isStop == "SLEEP") then
												sleepWithToast(2000,"Stop Tools 🛑")
												return
												elseif(isStop =="RUN") then
													toast("▶️")
												elseif(isStop == "RUNNING") then 
													toast("⏩")
												else
													sttcheck4 = sttcheck4 + 1
													sleepWithToast(3000,"Lổi không thể connect sever lần "..sttcheck4)
														if(sttcheck4 == 3) then 
															ChangeIPvia3G()
															usleep(1000000)
															check3g()
															goto startcheckstop24
														end
													goto startcheckstop4
												end
											--- END Kiểm tra dừng tools --
									local checkProfile = checkProfileLogindone()
											--- Kiểm tra dừng tools --
											::startcheckstop25::
											sttcheck5 = 0
											::startcheckstop5::
											local isStop = ""
												isStop = tostring(getStatusFromSever(sever,key))
												if (isStop == "SLEEP") then
												sleepWithToast(2000,"Stop Tools 🛑")
												return
												elseif(isStop =="RUN") then
													toast("▶️")
												elseif(isStop == "RUNNING") then 
													toast("⏩")
												else
													sttcheck5 = sttcheck5 + 1
													sleepWithToast(3000,"Lổi không thể connect sever lần "..sttcheck5)
														if(sttcheck5 == 3) then 
															ChangeIPvia3G()
															usleep(1000000)
															check3g()
															goto startcheckstop25
														end
													goto startcheckstop5
												end
											--- END Kiểm tra dừng tools --
										if (checkProfile == 1) then
											--- Kiểm tra dừng tools --
											::startcheckstop26::
											sttcheck6 = 0
											::startcheckstop6::
											local isStop = ""
												isStop = tostring(getStatusFromSever(sever,key))
												if (isStop == "SLEEP") then
												sleepWithToast(2000,"Stop Tools 🛑")
												return
												elseif(isStop =="RUN") then
													toast("▶️")
												elseif(isStop == "RUNNING") then 
													toast("⏩")
												else
													sttcheck6 = sttcheck6 + 1
													sleepWithToast(3000,"Lổi không thể connect sever lần "..sttcheck6)
														if(sttcheck6 == 3) then 
															ChangeIPvia3G()
															usleep(1000000)
															check3g()
															goto startcheckstop26
														end
													goto startcheckstop6
												end
											--- END Kiểm tra dừng tools --
										tuongtac(sever,key);
											--- Kiểm tra dừng tools --
											::startcheckstop27::
											sttcheck7 = 0
											::startcheckstop7::
											local isStop = ""
												isStop = tostring(getStatusFromSever(sever,key))
												if (isStop == "SLEEP") then
												sleepWithToast(2000,"Stop Tools 🛑")
												return
												elseif(isStop =="RUN") then
													toast("▶️")
												elseif(isStop == "RUNNING") then 
													toast("⏩")
												else
													sttcheck7 = sttcheck7 + 1
													sleepWithToast(3000,"Lổi không thể connect sever lần "..sttcheck7)
														if(sttcheck7 == 3) then 
															ChangeIPvia3G()
															usleep(1000000)
															check3g()
															goto startcheckstop27
														end
													goto startcheckstop7
												end
											--- END Kiểm tra dừng tools --
											updateTrangThaiTuongTac(sever,key,"Backup_Tài_Khoản")
										BackUpAcc(uid);
											--- Kiểm tra dừng tools --
											::startcheckstop28::
											sttcheck8 = 0
											::startcheckstop8::
											local isStop = ""
												isStop = tostring(getStatusFromSever(sever,key))
												if (isStop == "SLEEP") then
												sleepWithToast(2000,"Stop Tools 🛑")
												return
												elseif(isStop =="RUN") then
													toast("▶️")
												elseif(isStop == "RUNNING") then 
													toast("⏩")
												else
													sttcheck8 = sttcheck8 + 1
													sleepWithToast(3000,"Lổi không thể connect sever lần "..sttcheck8)
														if(sttcheck8 == 3) then 
															ChangeIPvia3G()
															usleep(1000000)
															check3g()
															goto startcheckstop28
														end
													goto startcheckstop8
												end
											--- END Kiểm tra dừng tools --
											local body = request(sever.."/getlistacc.php?key="..key.."&action=getlist&update=TUONGTAC&number="..sttacc) --update trạng thái đã tương tác lên sever
											sleepWithToast(15000,"Tạm Nghỉ Xíu Đở Nóng Máy Nè^^")
										else
											closeFacebook();
											--- Kiểm tra dừng tools --
											::startcheckstop29::
											sttcheck9 = 0
											::startcheckstop9::
											local isStop = ""
												isStop = tostring(getStatusFromSever(sever,key))
												if (isStop == "SLEEP") then
												sleepWithToast(2000,"Stop Tools 🛑")
												return
												elseif(isStop =="RUN") then
													toast("▶️")
												elseif(isStop == "RUNNING") then 
													toast("⏩")
												else
													sttcheck9 = sttcheck9 + 1
													sleepWithToast(3000,"Lổi không thể connect sever lần "..sttcheck9)
														if(sttcheck9 == 3) then 
															ChangeIPvia3G()
															usleep(1000000)
															check3g()
															goto startcheckstop29
														end
													goto startcheckstop9
												end
											--- END Kiểm tra dừng tools --
											goto hihi
										end
									else
										sleepWithToast(1000,"Tài Khoản "..uid.." CheckPoint ❌")
										delFolderInRestore(uid)
										UPdateCP = HTTPGet({ContentType = "application/json"},sever.."/getlistacc.php?key="..key.."&action=getlist&update=CHECKPOINT&number="..sttacc)
									end
	sttaccs = sttacc + 1
		UpdateSttAcc(sever,key,sttaccs)
goto hihi
else
	local body = request(sever.."/getlistacc.php?key="..key.."&action=getlist&update=DONERUN&number="..sttacc) --update trạng thái Sleep lên sever khi đã chạy hết list acc
end
-- Finish

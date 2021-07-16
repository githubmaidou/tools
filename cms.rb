##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# https://morningstarsecurity.com/research/whatweb
##
Plugin.define do
name "CMS"
authors [
  "Andrew Horton",
  # v0.2 # removed :probability. 
  "Brendan Coles <bcoles@gmail.com>", # v0.3 # 2011-02-21 # Added OS detection. 
  # Brendan Coles <bcoles@gmail.com>, # v0.4 # 2011-04-08 # Updated OS detection. 
]
version "0.4"
description "HTTP server header string. This plugin also attempts to identify the operating system from the server header."

# Passive #
passive do
	m=[]
	m << { :name=>"Dell-Printer", :string=>"Dell-Printer"} if @title=~/Dell Laser Printer/ 
#m << { :name=>"HP-OfficeJet-Printer", :string=>"HP-OfficeJet-Printer"} if @title=~/HP Officejet/ || @body=~/align="center/>HP Officejet/ 
m << { :name=>"Biscom-Delivery-Server", :string=>"Biscom-Delivery-Server"} if @body=~/\/bds\/stylesheets\/fds\.css/ || @body=~/\/bds\/includes\/fdsJavascript\.do/ 
m << { :name=>"DD-WRT", :string=>"DD-WRT"} if @body=~/style\/pwc\/ddwrt\.css/ 
m << { :name=>"ewebeditor", :string=>"ewebeditor"} if @body=~/\/ewebeditor\.htm?/ 
m << { :name=>"fckeditor", :string=>"fckeditor"} if @body=~/new FCKeditor/ 
m << { :name=>"xheditor", :string=>"xheditor"} if @body=~/xheditor_lang\/zh-cn\.js/||@body=~/class="xheditor/||@body=~/\.xheditor\(/ 
m << { :name=>"百为路由", :string=>"百为路由"} if @body=~/提交验证的id必须是ctl_submit/ 
m << { :name=>"锐捷NBR路由器", :string=>"锐捷NBR路由器"} if @body=~/free_nbr_login_form\.png/ 
m << { :name=>"mikrotik", :string=>"mikrotik"} if @title=~/RouterOS/ && @body=~/mikrotik/ 
m << { :name=>"ThinkSNS", :string=>"ThinkSNS"} if @body=~/\/addons\/theme\// && @body=~/全局变量/ 
m << { :name=>"h3c路由器", :string=>"h3c路由器"} if @title=~/Web user login/ && @body=~/nLanguageSupported/ 
m << { :name=>"jcg无线路由器", :string=>"jcg无线路由器"} if @title=~/Wireless Router/ && @body=~/:\/\/www\.jcgcn\.com/ 
m << { :name=>"D-Link_VoIP_Wireless_Router", :string=>"D-Link_VoIP_Wireless_Router"} if @title=~/D-Link VoIP Wireless Router/ 
m << { :name=>"arrisi_Touchstone", :string=>"arrisi_Touchstone"} if @title=~/Touchstone Status/ || @body=~/passWithWarnings/ 
m << { :name=>"ZyXEL", :string=>"ZyXEL"} if @body=~/Forms\/rpAuth_1/ 
m << { :name=>"Ruckus", :string=>"Ruckus"} if @body=~/mon\.  Tell me your username/ || @title=~/Ruckus Wireless Admin/ 
m << { :name=>"Motorola_SBG900", :string=>"Motorola_SBG900"} if @title=~/Motorola SBG900/ 
m << { :name=>"Wimax_CPE", :string=>"Wimax_CPE"} if @title=~/Wimax CPE Configuration/ 
m << { :name=>"Cisco_Cable_Modem", :string=>"Cisco_Cable_Modem"} if @title=~/Cisco Cable Modem/ 
m << { :name=>"Scientific-Atlanta_Cable_Modem", :string=>"Scientific-Atlanta_Cable_Modem"} if @title=~/Scientific-Atlanta Cable Modem/ 
m << { :name=>"rap", :string=>"rap"} if @body=~/\/jscripts\/rap_util\.js/ 
m << { :name=>"ZTE_MiFi_UNE", :string=>"ZTE_MiFi_UNE"} if @title=~/MiFi UNE 4G LTE/ 
m << { :name=>"ZTE_ZSRV2_Router", :string=>"ZTE_ZSRV2_Router"} if @title=~/ZSRV2路由器Web管理系统/ && @body=~/ZTE Corporation\. All Rights Reserved\./ 
#m << { :name=>"百为智能流控路由器", :string=>"百为智能流控路由器"} if @title=~/BYTEVALUE 智能流控路由器/ && @body=~/<a href="http:\/\/www\.bytevalue\.com\// target="_blank/>/ 
#m << { :name=>"乐视路由器", :string=>"乐视路由器"} if @title=~/乐视路由器/ && @body=~/<div class="login-logo/><\/div>/ 
m << { :name=>"Verizon_Wireless_Router", :string=>"Verizon_Wireless_Router"} if @title=~/Wireless Broadband Router Management Console/ && @body=~ /verizon_logo_blk\.gif/ 
m << { :name=>"Nexus_NX_router", :string=>"Nexus_NX_router"} if @body=~/http:\/\/nexuswifi\.com\// && @title=~/Nexus NX/ 
m << { :name=>"Verizon_Router", :string=>"Verizon_Router"} if @title=~/Verizon Router/ 
m << { :name=>"小米路由器", :string=>"小米路由器"} if @title=~/小米路由器/  
m << { :name=>"QNO_Router", :string=>"QNO_Router"} if @body=~/\/QNOVirtual_Keyboard\.js/ && @body=~/\/images\/login_img01_03\.gif/ 
m << { :name=>"爱快流控路由", :string=>"爱快流控路由"} if @title=~/爱快/ && @body=~/\/resources\/images\/land_prompt_ico01\.gif/ 
m << { :name=>"Django", :string=>"Django"} if @body=~/__admin_media_prefix__/ || @body=~/csrfmiddlewaretoken/ 
m << { :name=>"axis2-web", :string=>"axis2-web"} if @body=~/axis2-web\/css\/axis-style\.css/ 
m << { :name=>"Apache-Wicket", :string=>"Apache-Wicket"} if @body=~/xmlns:wicket/ || @body=~/\/org\.apache\.wicket\./ 
m << { :name=>"BEA-WebLogic-Server", :string=>"BEA-WebLogic-Server"} if @body=~/<h1>BEA WebLogic Server/ || @body=~/WebLogic/ 
m << { :name=>"EDK", :string=>"EDK"} if @body=~/<!-- \/killlistable\.tpl -->/ 
m << { :name=>"eDirectory", :string=>"eDirectory"} if @body=~/target="_blank">eDirectory&trade/ || @body=~/Powered by <a href="http:\/\/www\.edirectory\.com/ 
m << { :name=>"Esvon-Classifieds", :string=>"Esvon-Classifieds"} if @body=~/Powered by Esvon/ 
m << { :name=>"Fluid-Dynamics-Search-Engine", :string=>"Fluid-Dynamics-Search-Engine"} if @body=~/content="fluid dynamics/ 
m << { :name=>"mongodb", :string=>"mongodb"} if @body=~/<a href="\/_replSet">Replica set status<\/a><\/p>/ 
m << { :name=>"MVB2000", :string=>"MVB2000"} if @title=~/MVB2000/ || @body=~/The Magic Voice Box/ 
m << { :name=>"GPSweb", :string=>"GPSweb"} if @title=~/GPSweb/ 
m << { :name=>"phpinfo", :string=>"phpinfo"} if @title=~/phpinfo/ && @body=~/Virtual Directory Support / 
m << { :name=>"lemis管理系统", :string=>"lemis管理系统"} if @body=~/lemis\.WEB_APP_NAME/ 
m << { :name=>"FreeboxOS", :string=>"FreeboxOS"} if @title=~/Freebox OS/ || @body=~/logo_freeboxos/ 
m << { :name=>"Wimax_CPE", :string=>"Wimax_CPE"} if @title=~/Wimax CPE Configuration/ 
m << { :name=>"Scientific-Atlanta_Cable_Modem", :string=>"Scientific-Atlanta_Cable_Modem"} if @title=~/Scientific-Atlanta Cable Modem/ 
m << { :name=>"rap", :string=>"rap"} if @body=~/\/jscripts\/rap_util\.js/ 
m << { :name=>"ZTE_MiFi_UNE", :string=>"ZTE_MiFi_UNE"} if @title=~/MiFi UNE 4G LTE/ 
m << { :name=>"用友商战实践平台", :string=>"用友商战实践平台"} if @body=~/Login_Main_BG/ && @body=~/Login_Owner/ 
m << { :name=>"moosefs", :string=>"moosefs"} if @body=~/mfs\.cgi/ || @body=~/under-goal files/ 
m << { :name=>"蓝盾BDWebGuard", :string=>"蓝盾BDWebGuard"} if @body=~/BACKGROUND: url\(images\/loginbg\.jpg\) #e5f1fc/ 
m << { :name=>"护卫神网站安全系统", :string=>"护卫神网站安全系统"} if @title=~/护卫神\.网站安全系统/ 
m << { :name=>"phpDocumentor", :string=>"phpDocumentor"} if @body=~/Generated by phpDocumentor/ 
m << { :name=>"Adobe_ CQ5", :string=>"Adobe_ CQ5"} if @body=~/_jcr_content/ 
#m << { :name=>"Adobe_GoLive", :string=>"Adobe_GoLive"} if @body=~/generator/ content="Adobe GoLive/ 
#m << { :name=>"Adobe_RoboHelp", :string=>"Adobe_RoboHelp"} if @body=~/generator/ content="Adobe RoboHelp/ 
m << { :name=>"Amaya", :string=>"Amaya"} if @body=~/generator" content="Amaya/ 
m << { :name=>"OpenMas", :string=>"OpenMas"} if @title=~/OpenMas/ || @body=~/loginHead"><link href="App_Themes/ 
m << { :name=>"recaptcha", :string=>"recaptcha"} if @body=~/recaptcha_ajax\.js/ 
m << { :name=>"TerraMaster", :string=>"TerraMaster"} if @title=~/TerraMaster/ && @body=~/\/js\/common\.js/ 
m << { :name=>"创星伟业校园网群", :string=>"创星伟业校园网群"} if @body=~/javascripts\/float\.js/ && @body=~/vcxvcxv/ 
m << { :name=>"正方教务管理系统", :string=>"正方教务管理系统"} if @body=~/style\/base\/jw\.css/ 
m << { :name=>"UFIDA_NC", :string=>"UFIDA_NC"} if (@body=~/UFIDA/ && @body=~/logo\/images\//) || @body=~/logo\/images\/ufida_nc\.png/ 
m << { :name=>"北创图书检索系统", :string=>"北创图书检索系统"} if @body=~/opac_two/ 
m << { :name=>"北京清科锐华CEMIS", :string=>"北京清科锐华CEMIS"} if @body=~/\/theme\/2009\/image/ && @body=~/login\.asp/ 
m << { :name=>"RG-PowerCache内容加速系统", :string=>"RG-PowerCache内容加速系统"} if @title=~/RG-PowerCache/ 
m << { :name=>"sugon_gridview", :string=>"sugon_gridview"} if @body=~/\/common\/resources\/images\/common\/app\/gridview\.ico/ 
m << { :name=>"SLTM32_Configuration", :string=>"SLTM32_Configuration"} if @title=~/SLTM32 Web Configuration Pages / 
m << { :name=>"SHOUTcast", :string=>"SHOUTcast"} if @title=~/SHOUTcast Administrator/ 
m << { :name=>"milu_seotool", :string=>"milu_seotool"} if @body=~/plugin\.php?id=milu_seotool/ 
m << { :name=>"CISCO_EPC3925", :string=>"CISCO_EPC3925"} if @body=~/Docsis_system/ && @body=~/EPC3925/ 
m << { :name=>"HP_iLO(HP_Integrated_Lights-Out)", :string=>"HP_iLO(HP_Integrated_Lights-Out)"} if @body=~/js\/iLO\.js/ 
m << { :name=>"Siemens_SIMATIC", :string=>"Siemens_SIMATIC"} if @body=~/\/S7Web\.css/ 
m << { :name=>"Schneider_Quantum_140NOE77101", :string=>"Schneider_Quantum_140NOE77101"} if @body=~/indexLanguage/ && @body=~/html\/config\.js/ 
m << { :name=>"lynxspring_JENEsys", :string=>"lynxspring_JENEsys"} if @body=~/LX JENEsys/ 
m << { :name=>"Sophos_Web_Appliance", :string=>"Sophos_Web_Appliance"} if @title=~/Sophos Web Appliance/ 
m << { :name=>"Comcast_Business", :string=>"Comcast_Business"} if @body=~/cmn\/css\/common-min\.css/ 
m << { :name=>"Locus_SolarNOC", :string=>"Locus_SolarNOC"} if @title=~/SolarNOC - Login/ 
m << { :name=>"Everything", :string=>"Everything"} if (@body=~/Everything\.gif/||@body=~/everything\.png/) && @title=~/Everything/ 
m << { :name=>"honeywell NetAXS", :string=>"honeywell NetAXS"} if @title=~/Honeywell NetAXS/ 
m << { :name=>"Symantec Messaging Gateway", :string=>"Symantec Messaging Gateway"} if @title=~/Messaging Gateway/ 
m << { :name=>"xfinity", :string=>"xfinity"} if @title=~/Xfinity/ || @body=~/\/reset-meyer-1\.0\.min\.css/ 
m << { :name=>"网动云视讯平台", :string=>"网动云视讯平台"} if @title=~/Acenter/ || @body=~/\/js\/roomHeight\.js/ || @body=~/meetingShow!show\.action/ 
m << { :name=>"蓝凌EIS智慧协同平台", :string=>"蓝凌EIS智慧协同平台"} if @body=~/\/scripts\/jquery\.landray\.common\.js/ || @body=~/v11_QRcodeBar clr/ 
m << { :name=>"金山KingGate", :string=>"金山KingGate"} if @body=~/\/src\/system\/login\.php/ 
m << { :name=>"天融信入侵检测系统TopSentry", :string=>"天融信入侵检测系统TopSentry"} if @title=~/天融信入侵检测系统TopSentry/ 
m << { :name=>"天融信日志收集与分析系统", :string=>"天融信日志收集与分析系统"} if @title=~/天融信日志收集与分析系统/ 
m << { :name=>"天融信WEB应用防火墙", :string=>"天融信WEB应用防火墙"} if @title=~/天融信WEB应用防火墙/ 
m << { :name=>"天融信入侵防御系统TopIDP", :string=>"天融信入侵防御系统TopIDP"} if @body=~/天融信入侵防御系统TopIDP/ 
m << { :name=>"天融信Web应用安全防护系统", :string=>"天融信Web应用安全防护系统"} if @title=~/天融信Web应用安全防护系统/ 
m << { :name=>"天融信TopFlow", :string=>"天融信TopFlow"} if @body=~/天融信TopFlow/ 
m << { :name=>"汉码软件", :string=>"汉码软件"} if @title=~/汉码软件/ || @body=~/alt="汉码软件LOGO/ || @body=~/content="汉码软件/ 
m << { :name=>"凡科", :string=>"凡科"} if @body=~/凡科互联网科技股份有限公司/ || @body=~/content="凡科/ 
m << { :name=>"易分析", :string=>"易分析"} if @title=~/易分析 PHPStat Analytics/ || @body=~/PHPStat Analytics 网站数据分析系统/ 
m << { :name=>"phpems考试系统", :string=>"phpems考试系统"} if @title=~/phpems/ || @body=~/content="PHPEMS/ 
m << { :name=>"智睿软件", :string=>"智睿软件"} if @body=~/content="智睿软件/ || @body=~/Zhirui\.js/ 
m << { :name=>"Apabi数字资源平台", :string=>"Apabi数字资源平台"} if @body=~/Default\/apabi\.css/ || @body=~/<link href="HTTP:\/\/apabi/ || @title=~/数字资源平台/ 
m << { :name=>"Fortinet Firewall", :string=>"Fortinet Firewall"} if @title=~/Firewall Notification/ 
m << { :name=>"WDlinux", :string=>"WDlinux"} if @title=~/wdOS/ 
m << { :name=>"小脑袋", :string=>"小脑袋"} if @body=~/http:\/\/stat\.xiaonaodai\.com\/stat\.php/ 
m << { :name=>"天融信ADS管理平台", :string=>"天融信ADS管理平台"} if @title=~/天融信ADS管理平台/ 
m << { :name=>"天融信异常流量管理与抗拒绝服务系统", :string=>"天融信异常流量管理与抗拒绝服务系统"} if @title=~/天融信异常流量管理与抗拒绝服务系统/ 
m << { :name=>"天融信网络审计系统", :string=>"天融信网络审计系统"} if @body=~/onclick="dlg_download\(\)/ 
m << { :name=>"天融信脆弱性扫描与管理系统", :string=>"天融信脆弱性扫描与管理系统"} if @title=~/天融信脆弱性扫描与管理系统/ || @body=~/\/js\/report\/horizontalReportPanel\.js/ 
m << { :name=>"AllNewsManager_NET", :string=>"AllNewsManager_NET"} if @body=~/Powered by/ && @body=~/AllNewsManager/ 
m << { :name=>"Advanced-Image-Hosting-Script", :string=>"Advanced-Image-Hosting-Script"} if (@body=~/Powered by/ && @body=~/yabsoft\.com/ ) || @body=~/Welcome to install AIHS Script/ 
m << { :name=>"SNB股票交易软件", :string=>"SNB股票交易软件"} if @body=~/Copyright 2005–2009 <a href="http:\/\/www\.s-mo\.com>/ 
m << { :name=>"AChecker Web accessibility evaluation tool", :string=>"AChecker Web accessibility evaluation tool"} if @body=~/AChecker is a Web accessibility/ || @title=~/Checker : Web Accessibility Checker/ 
m << { :name=>"SCADAPLC", :string=>"SCADAPLC"} if @body=~/\/images\/rockcolor\.gif/ || @body=~/\/ralogo\.gif/ || @body=~/Ethernet Processor/ 
m << { :name=>".NET", :string=>".NET"} if @body=~/content="Visual Basic \.NET 7\.1/ 
m << { :name=>"phpmoadmin", :string=>"phpmoadmin"} if @title=~/phpmoadmin/ 
m << { :name=>"SOMOIDEA", :string=>"SOMOIDEA"} if @body=~/DESIGN BY SOMOIDEA/ 
m << { :name=>"Apache-Archiva", :string=>"Apache-Archiva"} if @title=~/Apache Archiva/ || @body=~/\/archiva\.js/ || @body=~/\/archiva\.css/ 
m << { :name=>"AM4SS", :string=>"AM4SS"} if @body=~/Powered by am4ss/ || @body=~/am4ss\.css/ 
m << { :name=>"ASPThai_Net-Webboard", :string=>"ASPThai_Net-Webboard"} if @body=~/ASPThai\.Net Webboard/ 
m << { :name=>"Astaro-Command-Center", :string=>"Astaro-Command-Center"} if @body=~/\/acc_aggregated_reporting\.js/ || @body=~/\/js\/_variables_from_backend\.js?/ 
m << { :name=>"ASP-Nuke", :string=>"ASP-Nuke"} if @body=~/CONTENT="ASP-Nuke/ || @body=~/content="ASPNUKE/ 
m << { :name=>"ASProxy", :string=>"ASProxy"} if @body=~/Surf the web invisibly using ASProxy power/ || @body=~/btnASProxyDisplayButton/ 
m << { :name=>"ashnews", :string=>"ashnews"} if @body=~/powered by/ && @body=~/ashnews/ 
m << { :name=>"Arab-Portal", :string=>"Arab-Portal"} if @body=~/Powered by: Arab/ 
m << { :name=>"AppServ", :string=>"AppServ"} if @body=~/appserv\/softicon\.gif/ || @body=~/index\.php?appservlang=th/ 
m << { :name=>"VZPP Plesk", :string=>"VZPP Plesk"} if @title=~/VZPP Plesk / 
m << { :name=>"ApPHP-Calendar", :string=>"ApPHP-Calendar"} if @body=~/This script was generated by ApPHP Calendar/ 
m << { :name=>"BigDump", :string=>"BigDump"} if @title=~/BigDump/ || @body=~/BigDump: Staggered MySQL Dump Importer/ 
m << { :name=>"BestShopPro", :string=>"BestShopPro"} if @body=~/content="www\.bst\.pl/ 
m << { :name=>"BASE", :string=>"BASE"} if @body=~/<!-- Basic Analysis and Security Engine \(BASE\) -->/ || @body=~/mailto:base@secureideas\.net/ 
m << { :name=>"Basilic", :string=>"Basilic"} if @body=~/\/Software\/Basilic/ 
m << { :name=>"Basic-PHP-Events-Lister", :string=>"Basic-PHP-Events-Lister"} if @body=~/Powered by: <a href="http:\/\/www\.mevin\.com\/>/ 
m << { :name=>"AV-Arcade", :string=>"AV-Arcade"} if @body=~/Powered by <a href="http:\/\/www\.avscripts\.net\/avarcade\// 
m << { :name=>"Auxilium-PetRatePro", :string=>"Auxilium-PetRatePro"} if @body=~/index\.php?cmd=11/ 
m << { :name=>"Atomic-Photo-Album", :string=>"Atomic-Photo-Album"} if @body=~/Powered by/ && @body=~/Atomic Photo Album/ 
m << { :name=>"Axis-PrintServer", :string=>"Axis-PrintServer"} if @body=~/psb_printjobs\.gif/ || @body=~/\/cgi-bin\/prodhelp\?prod="/ 
m << { :name=>"TeamViewer", :string=>"TeamViewer"} if @body=~/This site is running/&&@body=~/TeamViewer/ 
m << { :name=>"BlueQuartz", :string=>"BlueQuartz"} if @body=~/VALUE="Copyright \(C\) 2000, Cobalt Networks/ || @title=~/Login - BlueQuartz/ 
m << { :name=>"BlueOnyx", :string=>"BlueOnyx"} if @title=~/Login - BlueOnyx/ || @body=~/Thank you for using the BlueOnyx/ 
m << { :name=>"BMC-Remedy", :string=>"BMC-Remedy"} if @title=~/Remedy Mid Tier/ 
m << { :name=>"BM-Classifieds", :string=>"BM-Classifieds"} if @body=~/<!-- START HEADER TABLE - HOLDS GRAPHIC AND SITE NAME -->/ 
m << { :name=>"Citrix-Metaframe", :string=>"Citrix-Metaframe"} if @body=~/window\.location="\/Citrix\/MetaFrame/ 
m << { :name=>"Cogent-DataHub", :string=>"Cogent-DataHub"} if @body=~/\/images\/Cogent\.gif/ || @title=~/Cogent DataHub WebView/ 
m << { :name=>"ClipShare", :string=>"ClipShare"} if @body=~/<!--!!!!!!!!!!!!!!!!!!!!!!!!! Processing SCRIPT/ || @body=~/Powered By <a href="http:\/\/www\.clip-share\.com/ 
m << { :name=>"CGIProxy", :string=>"CGIProxy"} if @body=~/<a href="http:\/\/www\.jmarshall\.com\/tools\/cgiproxy\// 
m << { :name=>"CF-Image-Hosting-Script", :string=>"CF-Image-Hosting-Script"} if @body=~/Powered By <a href="http:\/\/codefuture\.co\.uk\/projects\/imagehost\// 
m << { :name=>"Censura", :string=>"Censura"} if @body=~/Powered by: <a href="http:\/\/www\.censura\.info/ 
m << { :name=>"CA-SiteMinder", :string=>"CA-SiteMinder"} if @body=~/<!-- SiteMinder Encoding/ 
m << { :name=>"Carrier-CCNWeb", :string=>"Carrier-CCNWeb"} if @body=~/\/images\/CCNWeb\.gif/ || @body=~/<APPLET CODE="JLogin\.class" ARCHIVE="JLogin\.jar/ 
m << { :name=>"cInvoice", :string=>"cInvoice"} if @body=~/Powered by <a href="http:\/\/www\.forperfect\.com\// 
m << { :name=>"Bomgar", :string=>"Bomgar"} if @body=~/alt="Remote Support by BOMGAR/ || @body=~/<a href="http:\/\/www\.bomgar\.com\/products" class="inverse/ 
m << { :name=>"cApexWEB", :string=>"cApexWEB"} if @body=~/\/capexweb\.parentvalidatepassword/ || @body=~/name="dfparentdb/ 
m << { :name=>"CameraLife", :string=>"CameraLife"} if @body=~/content="Camera Life/ || @body=~/This site is powered by Camera Life/ 
m << { :name=>"CalendarScript", :string=>"CalendarScript"} if @title=~/Calendar Administration : Login/ || @body=~/Powered by <A HREF="http:\/\/www\.CalendarScript\.com/ 
m << { :name=>"Cachelogic-Expired-Domains-Script", :string=>"Cachelogic-Expired-Domains-Script"} if @body=~/href="http:\/\/cachelogic\.net">Cachelogic\.net/ 
m << { :name=>"Burning-Board-Lite", :string=>"Burning-Board-Lite"} if @body=~/Powered by <b><a href="http:\/\/www\.woltlab\.de/ || @body=~/Powered by <b>Burning Board/ 
m << { :name=>"Buddy-Zone", :string=>"Buddy-Zone"} if @body=~/Powered By <a href="http:\/\/www\.vastal\.com/ || @body=~/>Buddy Zone<\/a>/ 
m << { :name=>"Bulletlink-Newspaper-Template", :string=>"Bulletlink-Newspaper-Template"} if @body=~/\/ModalPopup\/core-modalpopup\.css/ || @body=~/powered by bulletlink/ 
m << { :name=>"Brother-Printer", :string=>"Brother-Printer"} if @body=~/<FRAME SRC="\/printer\/inc_head\.html/ || @body=~/<IMG src="\/common\/image\/HL4040CN/ 
m << { :name=>"Daffodil-CRM", :string=>"Daffodil-CRM"} if @body=~/Powered by Daffodil/ || @body=~/Design & Development by Daffodil Software Ltd/ 
m << { :name=>"Cyn_in", :string=>"Cyn_in"} if @body=~/content="cyn\.in/ || @body=~/Powered by cyn\.in/ 
m << { :name=>"Oracle_OPERA", :string=>"Oracle_OPERA"} if @title=~/MICROS Systems Inc\., OPERA/ || @body=~/OperaLogin\/Welcome\.do/ 
m << { :name=>"DUgallery", :string=>"DUgallery"} if @body=~/Powered by DUportal/ ||  @body=~/DUgallery/ 
m << { :name=>"DublinCore", :string=>"DublinCore"} if @body=~/name="DC\.title/ 
m << { :name=>"DVWA", :string=>"DVWA"} if @title=~/Damn Vulnerable Web App \(DVWA\) - Login/ || @body=~/dvwa\/css\/login\.css/ || @body=~/dvwa\/images\/login_logo\.png/ 
m << { :name=>"DORG", :string=>"DORG"} if @title=~/DORG - / || @body=~/CONTENT="DORG/ 
m << { :name=>"VOS3000", :string=>"VOS3000"} if @title=~/VOS3000/||@body=~/<meta name="keywords" content="VOS3000/||@body=~/<meta name="description" content="VOS3000"/||@body=~/images\/vos3000\.ico/ 
m << { :name=>"Elite-Gaming-Ladders", :string=>"Elite-Gaming-Ladders"} if @body=~/Powered by Elite/ 
m << { :name=>"Entrans", :string=>"Entrans"} if @title=~/Entrans/ 
m << { :name=>"GateQuest-PHP-Site-Recommender", :string=>"GateQuest-PHP-Site-Recommender"} if @title=~/GateQuest/ 
m << { :name=>"Gallarific", :string=>"Gallarific"} if @body=~/content="Gallarific/ || @title=~/Gallarific > Sign in/ 
m << { :name=>"EZCMS", :string=>"EZCMS"} if @body=~/Powered by EZCMS/ || @body=~/EZCMS Content Management System/ 
m << { :name=>"Etano", :string=>"Etano"} if @body=~/Powered by <a href="http:\/\/www\.datemill\.com/ || @body=~/Etano<\/a>\. All Rights Reserved\./ 
m << { :name=>"GeoServer", :string=>"GeoServer"} if @body=~/\/org\.geoserver\.web\.GeoServerBasePage\// || @body=~/class="geoserver lebeg/ 
m << { :name=>"GeoNode", :string=>"GeoNode"} if @body=~/Powered by <a href="http:\/\/geonode\.org/ || @body=~/href="\/catalogue\/opensearch" title="GeoNode Search/ 
m << { :name=>"Help-Desk-Software", :string=>"Help-Desk-Software"} if @body=~/target="_blank">freehelpdesk\.org/ 
m << { :name=>"GridSite", :string=>"GridSite"} if @body=~/<a href="http:\/\/www\.gridsite\.org\/">GridSite/ || @body=~/gridsite-admin\.cgi?cmd/ 
m << { :name=>"GenOHM-SCADA", :string=>"GenOHM-SCADA"} if @title=~/GenOHM Scada Launcher/ || @body=~/\/cgi-bin\/scada-vis\// 
m << { :name=>"Infomaster", :string=>"Infomaster"} if @body=~/\/MasterView\.css/ || @body=~/\/masterView\.js/ || @body=~/\/MasterView\/MPLeftNavStyle\/PanelBar\.MPIFMA\.css/ 
m << { :name=>"Imageview", :string=>"Imageview"} if @body=~/content="Imageview/ || @body=~/By Jorge Schrauwen/ || @body=~/href="http:\/\/www\.blackdot\.be" title="Blackdot\.be/ 
m << { :name=>"Ikonboard", :string=>"Ikonboard"} if @body=~/content="Ikonboard/ || @body=~/Powered by <a href="http:\/\/www\.ikonboard\.com/ 
m << { :name=>"i-Gallery", :string=>"i-Gallery"} if @title=~/i-Gallery/ || @body=~/href="igallery\.asp/ 
m << { :name=>"OrientDB", :string=>"OrientDB"} if @title=~/Redirecting to OrientDB/ 
m << { :name=>"Solr", :string=>"Solr"} if @title=~/Solr Admin/||@body=~/SolrCore Initialization Failures/||@body=~/app_config\.solr_path/ 
m << { :name=>"Inout-Adserver", :string=>"Inout-Adserver"} if @body=~/Powered by Inoutscripts/ 
m << { :name=>"ionCube-Loader", :string=>"ionCube-Loader"} if @body=~/alt="ionCube logo/ 
m << { :name=>"Jamroom", :string=>"Jamroom"} if @body=~/content="Talldude Networks/ || @body=~/content="Jamroom/ 
m << { :name=>"Juniper-NetScreen-Secure-Access", :string=>"Juniper-NetScreen-Secure-Access"} if @body=~/\/dana-na\/auth\/welcome\.cgi/ 
m << { :name=>"Jcow", :string=>"Jcow"} if @body=~/content="Jcow/ || @body=~/content="Powered by Jcow/ || @body=~/end jcow_application_box/ 
m << { :name=>"InvisionPowerBoard", :string=>"InvisionPowerBoard"} if @body=~/Powered by <a href="http:\/\/www\.invisionboard\.com/ 
m << { :name=>"teamportal", :string=>"teamportal"} if @body=~/TS_expiredurl/ 
m << { :name=>"VisualSVN", :string=>"VisualSVN"} if @title=~/VisualSVN Server/ 
m << { :name=>"Redmine", :string=>"Redmine"} if @body=~/Redmine/ && @body=~/authenticity_token/ 
m << { :name=>"testlink", :string=>"testlink"} if @body=~/testlink_library\.js/ 
m << { :name=>"mantis", :string=>"mantis"} if @body=~/browser_search_plugin\.php?type=id/ || @body=~/MantisBT Team/ 
m << { :name=>"Mercurial", :string=>"Mercurial"} if @title=~/Mercurial repositories index/ 
m << { :name=>"activeCollab", :string=>"activeCollab"} if @body=~/powered by activeCollab/ || @body=~/<p id="powered_by"><a href="http:\/\/www\.activecollab\.com\// 
m << { :name=>"Collabtive", :string=>"Collabtive"} if @title=~/Login @ Collabtive/ 
m << { :name=>"CGI:IRC", :string=>"CGI:IRC"} if @title=~/CGI:IRC Login/ || @body=~/<!-- This is part of CGI:IRC/ || @body=~/<small id="ietest"><a href="http:\/\/cgiirc\.org\// 
m << { :name=>"DotA-OpenStats", :string=>"DotA-OpenStats"} if @body=~/content="dota OpenStats/ || @body=~/content="openstats\.iz\.rs/ 
m << { :name=>"eLitius", :string=>"eLitius"} if @body=~/content="eLitius/ || @body=~/target="_blank" title="Affiliate/ 
m << { :name=>"gCards", :string=>"gCards"} if @body=~/<a href="http:\/\/www\.gregphoto\.net\/gcards\/index\.php/ 
m << { :name=>"GpsGate-Server", :string=>"GpsGate-Server"} if @title=~/GpsGate Server - / 
m << { :name=>"iScripts-ReserveLogic", :string=>"iScripts-ReserveLogic"} if @body=~/Powered by <a href="http:\/\/www\.iscripts\.com\/reservelogic\// 
m << { :name=>"jobberBase", :string=>"jobberBase"} if @body=~/powered by/ && @body=~/http:\/\/www\.jobberbase\.com/ || @body=~/Jobber\.PerformSearch/ || @body=~/content="Jobberbase/ 
m << { :name=>"LuManager", :string=>"LuManager"} if @title=~/LuManager/ 
m << { :name=>"主机宝", :string=>"主机宝"} if @body=~/您访问的是主机宝服务器默认页/ 
m << { :name=>"wdcp管理系统", :string=>"wdcp管理系统"} if @title=~/wdcp服务器/ || @title=~/lanmp_wdcp 安装成功/ 
m << { :name=>"LANMP一键安装包", :string=>"LANMP一键安装包"} if @title=~/LANMP一键安装包/ 
m << { :name=>"UPUPW", :string=>"UPUPW"} if @title=~/UPUPW环境集成包/ 
m << { :name=>"wamp", :string=>"wamp"} if @title=~/WAMPSERVER/ 
m << { :name=>"easypanel", :string=>"easypanel"} if @body=~/\/vhost\/view\/default\/style\/login\.css/ 
m << { :name=>"awstats_admin", :string=>"awstats_admin"} if @body=~/generator" content="AWStats/ || @body=~/<frame name="mainleft" src="awstats\.pl?config/
m << { :name=>"awstats", :string=>"awstats"} if @body=~/awstats\.pl?config=/ 
m << { :name=>"moosefs", :string=>"moosefs"} if @body=~/mfs\.cgi/ || @body=~/under-goal files/ 
m << { :name=>"护卫神主机管理", :string=>"护卫神主机管理"} if @title=~/护卫神·主机管理系统/ 
m << { :name=>"bacula-web", :string=>"bacula-web"} if @title=~/Webacula/ || @title=~/Bacula Web/ || @title=~/Bacula-Web/ || @title=~/bacula-web/ 
m << { :name=>"Webmin", :string=>"Webmin"} if @title=~/Login to Webmin/ || @body=~/Webmin server on/ 
m << { :name=>"Synology_DiskStation", :string=>"Synology_DiskStation"} if @title=~/Synology DiskStation/ || @body=~/SYNO\.SDS\.Session/ 
m << { :name=>"Puppet_Node_Manager", :string=>"Puppet_Node_Manager"} if @title=~/Puppet Node Manager/ 
m << { :name=>"wdcp", :string=>"wdcp"} if @title=~/wdcp服务器/ 
m << { :name=>"Citrix-XenServer", :string=>"Citrix-XenServer"} if @body=~/Citrix Systems, Inc\. XenServer/ || @body=~/<a href="XenCenterSetup\.exe">XenCenter installer<\/a>/ 
m << { :name=>"DSpace", :string=>"DSpace"} if @body=~/content="DSpace/ || @body=~/<a href="http:\/\/www\.dspace\.org">DSpace Software/ 
m << { :name=>"dwr", :string=>"dwr"} if @body=~/\/dwr\/engine\.js/ 
m << { :name=>"eXtplorer", :string=>"eXtplorer"} if @title=~/Login - eXtplorer/ 
m << { :name=>"File-Upload-Manager", :string=>"File-Upload-Manager"} if @title=~/File Upload Manager/ || @body=~/<IMG SRC="\/images\/header\.jpg" ALT="File Upload Manager">/ 
m << { :name=>"FileNice", :string=>"FileNice"} if @body=~/the fantabulous mechanical eviltwin code machine/ || @body=~/fileNice\/fileNice\.js/ 
m << { :name=>"Glossword", :string=>"Glossword"} if @body=~/content="Glossword/ 
m << { :name=>"IBM-BladeCenter", :string=>"IBM-BladeCenter"} if @body=~/\/shared\/ibmbch\.png/ || @body=~/\/shared\/ibmbcs\.png/ || @body=~/alt="IBM BladeCenter/ 
m << { :name=>"iLO", :string=>"iLO"} if @body=~/href="http:\/\/www\.hp\.com\/go\/ilo/ || @title=~/HP Integrated Lights-Out/ 
m << { :name=>"Isolsoft-Support-Center", :string=>"Isolsoft-Support-Center"} if @body=~/Powered by: Support Center/ 
m << { :name=>"ISPConfig", :string=>"ISPConfig"} if @body=~/powered by <a HREF="http:\/\/www\.ispconfig\.org/ 
m << { :name=>"Kleeja", :string=>"Kleeja"} if @body=~/Powered by Kleeja/ 
m << { :name=>"Kloxo-Single-Server", :string=>"Kloxo-Single-Server"} if @body=~/src="\/img\/hypervm-logo\.gif/ || @body=~/\/htmllib\/js\/preop\.js/ || @title=~/HyperVM/ 
m << { :name=>"易瑞授权访问系统", :string=>"易瑞授权访问系统"} if @body=~/\/authjsp\/login\.jsp/ || @body=~/FE0174BB-F093-42AF-AB20-7EC621D10488/ 
m << { :name=>"MVB2000", :string=>"MVB2000"} if @title=~/MVB2000/ || @body=~/The Magic Voice Box/ 
m << { :name=>"NetShare_VPN", :string=>"NetShare_VPN"} if @title=~/NetShare/ && @title=~/VPN/ 
m << { :name=>"pmway_E4_crm", :string=>"pmway_E4_crm"} if @title=~/E4/ && @title=~/CRM/ 
m << { :name=>"srun3000计费认证系统", :string=>"srun3000计费认证系统"} if @title=~/srun3000/ 
m << { :name=>"Dolibarr", :string=>"Dolibarr"} if @body=~/Dolibarr Development Team/ 
m << { :name=>"Parallels Plesk Panel", :string=>"Parallels Plesk Panel"} if @body=~/Parallels IP Holdings GmbH/ 
m << { :name=>"EasyTrace(botwave)", :string=>"EasyTrace(botwave)"} if @title=~/EasyTrace/ && @body=~/login_page/ 
m << { :name=>"管理易", :string=>"管理易"} if @body=~/管理易/ && @body=~/minierp/ 
m << { :name=>"亿赛通DLP", :string=>"亿赛通DLP"} if @body=~/CDGServer3/ 
m << { :name=>"huawei_auth_server", :string=>"huawei_auth_server"} if @body=~/75718C9A-F029-11d1-A1AC-00C04FB6C223/ 
m << { :name=>"瑞友天翼_应用虚拟化系统 ", :string=>"瑞友天翼_应用虚拟化系统 "} if @title=~/瑞友天翼－应用虚拟化系统/ 
m << { :name=>"360企业版", :string=>"360企业版"} if @body=~/360EntInst/ 
m << { :name=>"用友erp-nc", :string=>"用友erp-nc"} if @body=~/\/nc\/servlet\/nc\.ui\.iufo\.login\.Index/ || @title=~/用友新世纪/ 
m << { :name=>"Array_Networks_VPN", :string=>"Array_Networks_VPN"} if @body=~/an_util\.js/ 
m << { :name=>"juniper_vpn", :string=>"juniper_vpn"} if @body=~/welcome\.cgi?p=logo/ 
m << { :name=>"CEMIS", :string=>"CEMIS"} if @body=~/<div id="demo" style="overflow:hidden/ && @title=~/综合项目管理系统登录/ 
m << { :name=>"zenoss", :string=>"zenoss"} if @body=~/\/zport\/dmd\// 
m << { :name=>"OpenMas", :string=>"OpenMas"} if @title=~/OpenMas/ || @body=~/loginHead"><link href="App_Themes/ 
m << { :name=>"Ultra_Electronics", :string=>"Ultra_Electronics"} if @body=~/\/preauth\/login\.cgi/ || @body=~/\/preauth\/style\.css/ 
m << { :name=>"NOALYSS", :string=>"NOALYSS"} if @title=~/NOALYSS/ 
m << { :name=>"ALCASAR", :string=>"ALCASAR"} if @body=~/valoriserDiv5/ 
m << { :name=>"orocrm", :string=>"orocrm"} if @body=~/\/bundles\/oroui\// 
m << { :name=>"Adiscon_LogAnalyzer", :string=>"Adiscon_LogAnalyzer"} if @title=~/Adiscon LogAnalyzer/ || (@body=~/Adiscon LogAnalyzer/ && @body=~/Adiscon GmbH/) 
m << { :name=>"Munin", :string=>"Munin"} if @body=~/Auto-generated by Munin/ || @body=~/munin-month\.html/ 
m << { :name=>"MRTG", :string=>"MRTG"} if @body=~/Command line is easier to read using "View Page Properties" of your browser/ || @title=~/MRTG Index Page/ || @body=~/commandline was: indexmaker/ 
m << { :name=>"元年财务软件", :string=>"元年财务软件"} if @body=~/yuannian\.css/ || @body=~/\/image\/logo\/yuannian\.gif/ 
m << { :name=>"UFIDA_NC", :string=>"UFIDA_NC"} if (@body=~/UFIDA/ && @body=~/logo\/images\//) || @body=~/logo\/images\/ufida_nc\.png/ 
m << { :name=>"Webmin", :string=>"Webmin"} if @title=~/Login to Webmin/ || @body=~/Webmin server on/ 
m << { :name=>"锐捷应用控制引擎", :string=>"锐捷应用控制引擎"} if @body=~/window\.open\("\/login\.do","airWin/ || @title=~/锐捷应用控制引擎/ 
m << { :name=>"Storm", :string=>"Storm"} if @title=~/Storm UI/ || @body=~/stormtimestr/ 
m << { :name=>"Centreon", :string=>"Centreon"} if @body=~/Generator" content="Centreon - Copyright/ || @title=~/Centreon - IT & Network Monitoring/ 
m << { :name=>"FortiGuard", :string=>"FortiGuard"} if @body=~/FortiGuard Web Filtering/ || @title=~/Web Filter Block Override/ || @body=~/\/XX\/YY\/ZZ\/CI\/MGPGHGPGPFGHCDPFGGOGFGEH/ 
m << { :name=>"PineApp", :string=>"PineApp"} if @title=~/PineApp WebAccess - Login/ || @body=~/\/admin\/css\/images\/pineapp\.ico/ 
m << { :name=>"CDR-Stats", :string=>"CDR-Stats"} if @title=~/CDR-Stats | Customer Interface/ || @body=~/\/static\/cdr-stats\/js\/jquery/ 
m << { :name=>"GenieATM", :string=>"GenieATM"} if @title=~/GenieATM/ || @body=~/Copyright© Genie Networks Ltd\./ || @body=~/defect 3531/ 
m << { :name=>"Spark_Worker", :string=>"Spark_Worker"} if @title=~/Spark Worker at/ 
m << { :name=>"Spark_Master", :string=>"Spark_Master"} if @title=~/Spark Master at/ 
m << { :name=>"Kibana", :string=>"Kibana"} if @title=~/Kibana/ || @body=~/kbnVersion/ 
m << { :name=>"UcSTAR", :string=>"UcSTAR"} if @title=~/UcSTAR 管理控制台/ 
m << { :name=>"i@Report", :string=>"i@Report"} if @body=~/ESENSOFT_IREPORT_SERVER/ || @body=~/com\.sanlink\.server\.Login/ || @body=~/ireportclient/ || @body=~/css\/ireport\.css/ 
m << { :name=>"帕拉迪统一安全管理和综合审计系统", :string=>"帕拉迪统一安全管理和综合审计系统"} if @body=~/module\/image\/pldsec\.css/ 
m << { :name=>"openEAP", :string=>"openEAP"} if @title=~/openEAP_统一登录门户/ 
m << { :name=>"Dorado", :string=>"Dorado"} if @title=~/Dorado Login Page/ 
m << { :name=>"金龙卡金融化一卡通网站查询子系统", :string=>"金龙卡金融化一卡通网站查询子系统"} if @title=~/金龙卡金融化一卡通网站查询子系统/ || @body=~/location\.href="homeLogin\.action/ 
m << { :name=>"一采通", :string=>"一采通"} if @body=~/\/custom\/GroupNewsList\.aspx?GroupId=/
m << { :name=>"埃森诺网络服务质量检测系统", :string=>"埃森诺网络服务质量检测系统"} if @title=~/埃森诺网络服务质量检测系统 / 
m << { :name=>"惠尔顿上网行为管理系统", :string=>"惠尔顿上网行为管理系统"} if @body=~/updateLoginPswd\.php/ && @body=~/PassroedEle/ 
m << { :name=>"ACSNO网络探针", :string=>"ACSNO网络探针"} if @title=~/探针管理与测试系统-登录界面/ 
m << { :name=>"绿盟下一代防火墙", :string=>"绿盟下一代防火墙"} if @title=~/NSFOCUS NF/ 
m << { :name=>"用友U8", :string=>"用友U8"} if @body=~/getFirstU8Accid/ 
m << { :name=>"华为（HUAWEI）安全设备", :string=>"华为（HUAWEI）安全设备"} if @body=~/sweb-lib\/resource\// 
m << { :name=>"网神防火墙", :string=>"网神防火墙"} if @title=~/secgate 3600/ || @body=~/css\/lsec\/login\.css/ 
m << { :name=>"cisco UCM", :string=>"cisco UCM"} if @body=~/\/ccmadmin\// || @title=~/Cisco Unified/ 
m << { :name=>"panabit智能网关", :string=>"panabit智能网关"} if @title=~/panabit/ 
m << { :name=>"久其通用财表系统", :string=>"久其通用财表系统"} if @body=~/<nobr>北京久其软件股份有限公司/ || @body=~/\/netrep\/intf/ || @body=~/\/netrep\/message2\// 
m << { :name=>"soeasy网站集群系统", :string=>"soeasy网站集群系统"} if @body=~/EGSS_User/ || @title=~/SoEasy网站集群/ 
m << { :name=>"畅捷通", :string=>"畅捷通"} if @title=~/畅捷通/ 
m << { :name=>"科来RAS", :string=>"科来RAS"} if @title=~/科来网络回溯/ || @body=~/科来软件 版权所有/ || @body=~/i18ninit\.min\.js/ 
m << { :name=>"科迈RAS系统", :string=>"科迈RAS系统"} if @title=~/科迈RAS/ || @body=~/type="application\/npRas/ || @body=~/远程技术支持请求：<a href="http:\/\/www\.comexe\.cn/ 
m << { :name=>"单点CRM系统", :string=>"单点CRM系统"} if @body=~/URL=general\/ERP\/LOGIN\// || @body=~/content="单点CRM系统/ ||@title=~/客户关系管理-CRM/ 
m << { :name=>"中国期刊先知网", :string=>"中国期刊先知网"} if @body=~/本系统由<span class="STYLE1" ><a href="http:\/\/www\.firstknow\.cn/ || @body=~/<img src="images\/logoknow\.png/
m << { :name=>"loyaa信息自动采编系统", :string=>"loyaa信息自动采编系统"} if @body=~/\/Loyaa\/common\.lib\.js/ 
m << { :name=>"浪潮政务系统", :string=>"浪潮政务系统"} if @body=~/OnlineQuery\/QueryList\.aspx/ || @title=~/浪潮政务/ || @body=~/LangChao\.ECGAP\.OutPortal/ 
m << { :name=>"悟空CRM", :string=>"悟空CRM"} if @title=~/悟空CRM/ || @body=~/\/Public\/js\/5kcrm\.js/ 
m << { :name=>"用友ufida", :string=>"用友ufida"} if @body=~/\/System\/Login\/Login\.asp?AppID/
m << { :name=>"金蝶EAS", :string=>"金蝶EAS"} if @body=~/easSessionId/ 
m << { :name=>"金蝶政务GSiS", :string=>"金蝶政务GSiS"} if @body=~/\/kdgs\/script\/kdgs\.js/ 
m << { :name=>"网御上网行为管理系统", :string=>"网御上网行为管理系统"} if @title=~/Leadsec ACM/ 
m << { :name=>"ZKAccess 门禁管理系统", :string=>"ZKAccess 门禁管理系统"} if @body=~/\/logoZKAccess_zh-cn\.jpg/ 
m << { :name=>"福富安全基线管理", :string=>"福富安全基线管理"} if @body=~/align="center/>福富软件/ 
m << { :name=>"中控智慧时间安全管理平台", :string=>"中控智慧时间安全管理平台"} if @title=~/ZKECO 时间&安全管理平台/ 
m << { :name=>"天融信安全管理系统", :string=>"天融信安全管理系统"} if @title=~/天融信安全管理/ 
m << { :name=>"锐捷 RG-DBS", :string=>"锐捷 RG-DBS"} if @body=~/\/css\/impl-security\.css/ || @body=~/\/dbaudit\/authenticate/ 
m << { :name=>"深信服防火墙类产品", :string=>"深信服防火墙类产品"} if @body=~/SANGFOR FW/ 
m << { :name=>"天融信网络卫士过滤网关", :string=>"天融信网络卫士过滤网关"} if @title=~/天融信网络卫士过滤网关/ 
m << { :name=>"天融信网站监测与自动修复系统", :string=>"天融信网站监测与自动修复系统"} if @title=~/天融信网站监测与自动修复系统/ 
m << { :name=>"天融信 TopAD", :string=>"天融信 TopAD"} if @title=~/天融信 TopAD/ 
m << { :name=>"Apache-Forrest", :string=>"Apache-Forrest"} if @body=~/content="Apache Forrest/ || @body=~/name="Forrest/ 
m << { :name=>"Advantech-WebAccess", :string=>"Advantech-WebAccess"} if @body=~/\/bw_templete1\.dwt/ || @body=~/\/broadweb\/WebAccessClientSetup\.exe/ || @body=~/\/broadWeb\/bwuconfig\.asp/ 
m << { :name=>"URP教务系统", :string=>"URP教务系统"} if @title=~/URP 综合教务系统/ || @body=~/北京清元优软科技有限公司/ 
m << { :name=>"H3C公司产品", :string=>"H3C公司产品"} if @body=~/service@h3c\.com/ || (@body=~/Copyright/ && @body=~/H3C Corporation/) || @body=~/icg_helpScript\.js/ 
m << { :name=>"Huawei HG520 ADSL2+ Router", :string=>"Huawei HG520 ADSL2+ Router"} if @title=~/Huawei HG520/ 
m << { :name=>"Huawei B683V", :string=>"Huawei B683V"} if @title=~/Huawei B683V/ 
m << { :name=>"HUAWEI ESPACE 7910", :string=>"HUAWEI ESPACE 7910"} if @title=~/HUAWEI ESPACE 7910/ 
m << { :name=>"Huawei HG630", :string=>"Huawei HG630"} if @title=~/Huawei HG630/ 
m << { :name=>"Huawei B683", :string=>"Huawei B683"} if @title=~/Huawei B683/ 
m << { :name=>"华为 MCU", :string=>"华为 MCU"} if @body=~/McuR5-min\.js/ || @body=~/MCUType\.js/ || @title=~/huawei MCU/ 
m << { :name=>"HUAWEI Inner Web", :string=>"HUAWEI Inner Web"} if @title=~/HUAWEI Inner Web/ || @body=~/hidden_frame\.html/ 
m << { :name=>"HUAWEI CSP", :string=>"HUAWEI CSP"} if @title=~/HUAWEI CSP/ 
m << { :name=>"华为 NetOpen", :string=>"华为 NetOpen"} if @body=~/\/netopen\/theme\/css\/inFrame\.css/ || @title=~/Huawei NetOpen System/ 
m << { :name=>"校园卡管理系统", :string=>"校园卡管理系统"} if @body=~/Harbin synjones electronic/ || @body=~/document\.FormPostds\.action="xxsearch\.action/ || @body=~/\/shouyeziti\.css/ 
m << { :name=>"OBSERVA telcom", :string=>"OBSERVA telcom"} if @title=~/OBSERVA/ 
m << { :name=>"汉柏安全网关", :string=>"汉柏安全网关"} if @title=~/OPZOON - / 
m << { :name=>"b2evolution", :string=>"b2evolution"} if @body=~/\/powered-by-b2evolution-150t\.gif/ || @body=~/Powered by b2evolution/ || @body=~/content="b2evolution/ 
m << { :name=>"AvantFAX", :string=>"AvantFAX"} if @body=~/content="Web 2\.0 HylaFAX/ || @body=~/images\/avantfax-big\.png/ 
m << { :name=>"Aurion", :string=>"Aurion"} if @body=~/<!-- Aurion Teal will be used as the login-time default/ || @body=~/\/aurion\.js/ 
m << { :name=>"Cisco-IP-Phone", :string=>"Cisco-IP-Phone"} if @body=~/Cisco Unified Wireless IP Phone/ 
m << { :name=>"Cisco-VPN-3000-Concentrator", :string=>"Cisco-VPN-3000-Concentrator"} if @title=~/Cisco Systems, Inc\. VPN 3000 Concentrator/ 
m << { :name=>"BugTracker.NET", :string=>"BugTracker.NET"} if @body=~/href="btnet\.css/ || @body=~/valign=middle><a href=http:\/\/ifdefined\.com\/bugtrackernet\.html>/ || @body=~/<div class=logo>BugTracker\.NET/ 
m << { :name=>"BugFree", :string=>"BugFree"} if @body=~/id="logo" alt=BugFree/ || @body=~/class="loginBgImage" alt="BugFree/ ||  @title=~/BugFree/ || @body=~/name="BugUserPWD/ 
m << { :name=>"cPassMan", :string=>"cPassMan"} if @title=~/Collaborative Passwords Manager/ 
m << { :name=>"splunk", :string=>"splunk"} if @body=~/Splunk\.util\.normalizeBoolean/ 
m << { :name=>"DrugPak", :string=>"DrugPak"} if @body=~/Powered by DrugPak/ || @body=~/\/dplimg\/DPSTYLE\.CSS/ 
m << { :name=>"DMXReady-Portfolio-Manager", :string=>"DMXReady-Portfolio-Manager"} if @body=~/\/css\/PortfolioManager\/styles_display_page\.css/ || @body=~/rememberme_portfoliomanager/ 
m << { :name=>"eGroupWare", :string=>"eGroupWare"} if @body=~/content="eGroupWare/ 
m << { :name=>"eSyndiCat", :string=>"eSyndiCat"} if @body=~/content="eSyndiCat/ 
m << { :name=>"Epiware", :string=>"Epiware"} if @body=~/Epiware - Project and Document Management/ 
m << { :name=>"eMeeting-Online-Dating-Software", :string=>"eMeeting-Online-Dating-Software"} if @body=~/eMeeting Dating Software/ || @body=~/\/_eMeetingGlobals\.js/ 
m << { :name=>"FreeNAS", :string=>"FreeNAS"} if @body=~/title="Welcome to FreeNAS/ || @body=~/\/images\/ui\/freenas-logo\.png/ 
m << { :name=>"FestOS", :string=>"FestOS"} if @body=~/title="FestOS/ || @body=~/css\/festos\.css/ 
m << { :name=>"eTicket", :string=>"eTicket"} if @body=~/Powered by eTicket/ || @body=~/<a href="http:\/\/www\.eticketsupport\.com" target="_blank">/ || @body=~/\/eticket\/eticket\.css/ 
m << { :name=>"FileVista", :string=>"FileVista"} if @body=~/Welcome to FileVista/ || @body=~/<a href="http:\/\/www\.gleamtech\.com\/products\/filevista\/web-file-manager/ 
m << { :name=>"Google-Talk-Chatback", :string=>"Google-Talk-Chatback"} if @body=~/www\.google\.com\/talk\/service\// 
m << { :name=>"Flyspray", :string=>"Flyspray"} if @body=~/Powered by Flyspray/ 
m << { :name=>"HP-StorageWorks-Library", :string=>"HP-StorageWorks-Library"} if @title=~/HP StorageWorks/ 
m << { :name=>"HostBill", :string=>"HostBill"} if @body=~/Powered by <a href="http:\/\/hostbillapp\.com/ || @body=~/<strong>HostBill/ 
m << { :name=>"IBM-Cognos", :string=>"IBM-Cognos"} if @body=~/\/cgi-bin\/cognos\.cgi/ || @body=~/Cognos &#26159; International Business Machines Corp/ 
m << { :name=>"iTop", :string=>"iTop"} if @title=~/iTop Login/ || @body=~/href="http:\/\/www\.combodo\.com\/itop/ 
m << { :name=>"Kayako-SupportSuite", :string=>"Kayako-SupportSuite"} if @body=~/Powered By Kayako eSupport/ || @body=~/Help Desk Software By Kayako eSupport/ 
m << { :name=>"JXT-Consulting", :string=>"JXT-Consulting"} if @body=~/id="jxt-popup-wrapper/ || @body=~/Powered by JXT Consulting/ 
m << { :name=>"Fastly cdn", :string=>"Fastly cdn"} if @body=~/fastcdn\.org/ 
m << { :name=>"JBoss_AS", :string=>"JBoss_AS"} if @body=~/Manage this JBoss AS Instance/ 
m << { :name=>"oracle_applicaton_server", :string=>"oracle_applicaton_server"} if @body=~/OraLightHeaderSub/ 
m << { :name=>"Avaya-Aura-Utility-Server", :string=>"Avaya-Aura-Utility-Server"} if @body=~/vmsTitle">Avaya Aura&#8482;&nbsp;Utility Server/ || @body=~/\/webhelp\/Base\/Utility_toc\.htm/ 
m << { :name=>"DnP Firewall", :string=>"DnP Firewall"} if @body=~/Powered by DnP Firewall/ || @body=~/dnp_firewall_redirect/ 
m << { :name=>"PaloAlto_Firewall", :string=>"PaloAlto_Firewall"} if @body=~/Access to the web page you were trying to visit has been blocked in accordance with company policy/ 
m << { :name=>"梭子鱼防火墙", :string=>"梭子鱼防火墙"} if @body=~/http:\/\/www\.barracudanetworks\.com?a=bsf_product" class="transbutton/ && @body=~/\/cgi-mod\/header_logo\.cgi/ 
m << { :name=>"IndusGuard_WAF", :string=>"IndusGuard_WAF"} if @title=~/IndusGuard WAF/ && @body=~ /wafportal\/wafportal\.nocache\.js/ 
m << { :name=>"网御WAF", :string=>"网御WAF"} if @body=~ /<div id="divLogin">/ && @title=~/网御WAF/ 
m << { :name=>"NSFOCUS_WAF", :string=>"NSFOCUS_WAF"} if @title=~/WAF NSFOCUS/ && @body=~ /\/images\/logo\/nsfocus\.png/ 
m << { :name=>"斐讯Fortress", :string=>"斐讯Fortress"} if @title=~/斐讯Fortress防火墙/ && @body=~/<meta name="author" content="上海斐讯数据通信技术有限公司" \/>/ 
m << { :name=>"Sophos Web Appliance", :string=>"Sophos Web Appliance"} if @title=~/Sophos Web Appliance/ || @body=~/resources\/images\/sophos_web\.ico/ || @body=~/url\(resources\/images\/en\/login_swa\.jpg\)/ 
m << { :name=>"Barracuda-Spam-Firewall", :string=>"Barracuda-Spam-Firewall"} if @title=~/Barracuda Spam & Virus Firewall: Welcome/ || @body=~/\/barracuda\.css/ || @body=~/http:\/\/www\.barracudanetworks\.com?a=bsf_product/ 
m << { :name=>"DnP-Firewall", :string=>"DnP-Firewall"} if @title=~/Forum Gateway - Powered by DnP Firewall/ || @body=~/name="dnp_firewall_redirect/ ||  @body=~/<form name=dnp_firewall/ 
m << { :name=>"H3C-SecBlade-FireWall", :string=>"H3C-SecBlade-FireWall"} if @body=~/js\/MulPlatAPI\.js/ 
m << { :name=>"锐捷NBR路由器", :string=>"锐捷NBR路由器"} if @body=~/free_nbr_login_form\.png/ 
m << { :name=>"mikrotik", :string=>"mikrotik"} if @title=~/RouterOS/ && @body=~/mikrotik/ 
m << { :name=>"h3c路由器", :string=>"h3c路由器"} if @title=~/Web user login/ && @body=~/nLanguageSupported/ 
m << { :name=>"jcg无线路由器", :string=>"jcg无线路由器"} if @title=~/Wireless Router/ && @body=~/http:\/\/www\.jcgcn\.com/ 
m << { :name=>"Comcast_Business_Gateway", :string=>"Comcast_Business_Gateway"} if @body=~/Comcast Business Gateway/ 
m << { :name=>"AirTiesRouter", :string=>"AirTiesRouter"} if @title=~/Airties/ 
m << { :name=>"3COM NBX", :string=>"3COM NBX"} if @title=~/NBX NetSet/ || @body=~/splashTitleIPTelephony/ 
m << { :name=>"H3C ER2100n", :string=>"H3C ER2100n"} if @title=~/ER2100n系统管理/ 
m << { :name=>"H3C ICG 1000", :string=>"H3C ICG 1000"} if @title=~/ICG 1000系统管理/ 
m << { :name=>"H3C AM8000", :string=>"H3C AM8000"} if @title=~/AM8000/ 
m << { :name=>"H3C ER8300G2", :string=>"H3C ER8300G2"} if @title=~/ER8300G2系统管理/ 
m << { :name=>"H3C ER3108GW", :string=>"H3C ER3108GW"} if @title=~/ER3108GW系统管理/ 
m << { :name=>"H3C ER6300", :string=>"H3C ER6300"} if @title=~/ER6300系统管理/ 
m << { :name=>"H3C ICG1000", :string=>"H3C ICG1000"} if @title=~/ICG1000系统管理/ 
m << { :name=>"H3C ER3260G2", :string=>"H3C ER3260G2"} if @title=~/ER3260G2系统管理/ 
m << { :name=>"H3C ER3108G", :string=>"H3C ER3108G"} if @title=~/ER3108G系统管理/ 
m << { :name=>"H3C ER2100", :string=>"H3C ER2100"} if @title=~/ER2100系统管理/ 
m << { :name=>"H3C ER3200", :string=>"H3C ER3200"} if @title=~/ER3200系统管理/ 
m << { :name=>"H3C ER8300", :string=>"H3C ER8300"} if @title=~/ER8300系统管理/ 
m << { :name=>"H3C ER5200G2", :string=>"H3C ER5200G2"} if @title=~/ER5200G2系统管理/ 
m << { :name=>"H3C ER6300G2", :string=>"H3C ER6300G2"} if @title=~/ER6300G2系统管理/ 
m << { :name=>"H3C ER2100V2", :string=>"H3C ER2100V2"} if @title=~/ER2100V2系统管理/ 
m << { :name=>"H3C ER3260", :string=>"H3C ER3260"} if @title=~/ER3260系统管理/ 
m << { :name=>"H3C ER3100", :string=>"H3C ER3100"} if @title=~/ER3100系统管理/ 
m << { :name=>"H3C ER5100", :string=>"H3C ER5100"} if @title=~/ER5100系统管理/ 
m << { :name=>"H3C ER5200", :string=>"H3C ER5200"} if @title=~/ER5200系统管理/ 
m << { :name=>"UBNT_UniFi系列路由", :string=>"UBNT_UniFi系列路由"} if @title=~/UniFi/ && @body=~/<div class="appGlobalHeader">/ 
m << { :name=>"AnyGate", :string=>"AnyGate"} if @title=~/AnyGate/ || @body=~/\/anygate\.php/ 
m << { :name=>"Astaro-Security-Gateway", :string=>"Astaro-Security-Gateway"} if @body=~/wfe\/asg\/js\/app_selector\.js?t/ || @body=~/\/doc\/astaro-license\.txt/ || @body=~/\/js\/_variables_from_backend\.js?t=/
m << { :name=>"Aruba-Device", :string=>"Aruba-Device"} if @body=~/\/images\/arubalogo\.gif/ || (@body=~/Copyright/ && @body=~/Aruba Networks/) 
m << { :name=>"ARRIS-Touchstone-Router", :string=>"ARRIS-Touchstone-Router"} if (@body=~/Copyright/ && @body=~/ARRIS Group/) || @body=~/\/arris_style\.css/ 
m << { :name=>"AP-Router", :string=>"AP-Router"} if @title=~/AP Router New Generation/ 
m << { :name=>"Belkin-Modem", :string=>"Belkin-Modem"} if @body=~/content="Belkin/ 
m << { :name=>"Dell OpenManage Switch Administrator", :string=>"Dell OpenManage Switch Administrator"} if @title=~/Dell OpenManage Switch Administrator/ 
m << { :name=>"EDIMAX", :string=>"EDIMAX"} if @title=~/EDIMAX Technology/ || @body=~/content="Edimax/ 
m << { :name=>"eBuilding-Network-Controller", :string=>"eBuilding-Network-Controller"} if @title=~/eBuilding Web/ 
m << { :name=>"ipTIME-Router", :string=>"ipTIME-Router"} if @title=~/networks - ipTIME/ || @body=~/href=iptime\.css/ 
m << { :name=>"I-O-DATA-Router", :string=>"I-O-DATA-Router"} if @title=~/I-O DATA Wireless Broadband Router/ 
m << { :name=>"phpshe", :string=>"phpshe"} if @body=~/Powered by phpshe/ || @body=~/content="phpshe/ 
m << { :name=>"ThinkSAAS", :string=>"ThinkSAAS"} if @body=~/\/app\/home\/skins\/default\/style\.css/ 
m << { :name=>"e-tiller", :string=>"e-tiller"} if @body=~/reader\/view_abstract\.aspx/ 
m << { :name=>"DouPHP", :string=>"DouPHP"} if @body=~/Powered by DouPHP/ || (@body=~/controlBase/ && @body=~/indexLeft/ && @body=~/recommendProduct/) 
m << { :name=>"twcms", :string=>"twcms"} if @body=~/\/twcms\/theme\// && @body=~/\/css\/global\.css/ 
m << { :name=>"SiteServer", :string=>"SiteServer"} if (@body=~/Powered by/ && @body=~/http:\/\/www\.siteserver\.cn/ && @body=~/SiteServer CMS/) || @title=~/Powered by SiteServer CMS/ || @body=~/T_系统首页模板/ || (@body=~/siteserver/ && @body=~/sitefiles/) 
m << { :name=>"Joomla", :string=>"Joomla"} if @body=~/content="Joomla/ || (@body=~/\/media\/system\/js\/core\.js/ && @body=~/\/media\/system\/js\/mootools-core\.js/) 
m << { :name=>"kesionCMS", :string=>"kesionCMS"} if @body=~/\/ks_inc\/common\.js/ || @body=~/publish by KesionCMS/ 
m << { :name=>"CMSTop", :string=>"CMSTop"} if @body=~/\/css\/cmstop-common\.css/ || @body=~/\/js\/cmstop-common\.js/ || @body=~/cmstop-list-text\.css/ || @body=~/<a class="poweredby" href="http:\/\/www\.cmstop\.com/
m << { :name=>"ESPCMS", :string=>"ESPCMS"} if @title=~/Powered by ESPCMS/ || @body=~/Powered by ESPCMS/ || (@body=~/infolist_fff/ && @body=~/\/templates\/default\/style\/tempates_div\.css/) 
m << { :name=>"74cms", :string=>"74cms"} if @body=~/content="74cms\.com/ || @body=~/content="骑士CMS/ || @body=~/Powered by <a href="http:\/\/www\.74cms\.com\// || (@body=~/\/templates\/default\/css\/common\.css/ && @body=~/selectjobscategory/) 
m << { :name=>"Foosun", :string=>"Foosun"} if @body=~/Created by DotNetCMS/ || @body=~/For Foosun/ || @body=~/Powered by www\.Foosun\.net,Products:Foosun Content Manage system/ 
m << { :name=>"PhpCMS", :string=>"PhpCMS"} if (@body=~/Powered by/ && @body=~/http:\/\/www\.phpcms\.cn/) || @body=~/content="Phpcms/ || @body=~/Powered by Phpcms/ || @body=~/data\/config\.js/ || @body=~/\/index\.php?m=content&c=index&a=lists/ || @body=~/\/index\.php?m=content&amp;c=index&amp;a=lists/ 
m << { :name=>"DedeCMS", :string=>"DedeCMS"} if @body=~/Power by DedeCms/ || (@body=~/Powered by/ && @body=~/http:\/\/www\.dedecms\.com\// && @body=~/DedeCMS/) || @body=~/\/templets\/default\/style\/dedecms\.css/ || @title=~/Powered by DedeCms/  
m << { :name=>"ASPCMS", :string=>"ASPCMS"} if @title=~/Powered by ASPCMS/ || @body=~/content="ASPCMS/ || @body=~/\/inc\/AspCms_AdvJs\.asp/ 
m << { :name=>"MetInfo", :string=>"MetInfo"} if @title=~/Powered by MetInfo/ || @body=~/content="MetInfo/ || @body=~/powered_by_metinfo/ || @body=~/\/images\/css\/metinfo\.css/ 
m << { :name=>"Npoint", :string=>"Npoint"} if @title=~/Powered by Npoint/ 
m << { :name=>"捷点JCMS", :string=>"捷点JCMS"} if @body=~/Publish By JCms2010/ 
m << { :name=>"帝国EmpireCMS", :string=>"帝国EmpireCMS"} if @title=~/Powered by EmpireCMS/ 
m << { :name=>"JEECMS", :string=>"JEECMS"} if @title=~/Powered by JEECMS/ || (@body=~/Powered by/ && @body=~/http:\/\/www\.jeecms\.com/ && @body=~/JEECMS/) 
m << { :name=>"IdeaCMS", :string=>"IdeaCMS"} if @body=~/Powered By IdeaCMS/ || @body=~/m_ctr32/ 
m << { :name=>"TCCMS", :string=>"TCCMS"} if @title=~/Power By TCCMS/ || (@body=~/index\.php?ac=link_more/ && @body=~/index\.php?ac=news_list/) 
m << { :name=>"webplus", :string=>"webplus"} if @body=~/webplus/ && @body=~/高校网站群管理平台/ 
m << { :name=>"Dolibarr", :string=>"Dolibarr"} if @body=~/Dolibarr Development Team/ 
m << { :name=>"Telerik Sitefinity", :string=>"Telerik Sitefinity"} if @body=~/Telerik\.Web\.UI\.WebResource\.axd/ || @body=~/content="Sitefinity/ 
m << { :name=>"PageAdmin", :string=>"PageAdmin"} if @body=~/content="PageAdmin CMS/ || @body=~/\/e\/images\/favicon\.ico/ 
m << { :name=>"sdcms", :string=>"sdcms"} if @title=~/powered by sdcms/ || (@body=~/var webroot/ && @body=~/\/js\/sdcms\.js/) 
m << { :name=>"EnterCRM", :string=>"EnterCRM"} if @body=~/EnterCRM/ 
m << { :name=>"易普拉格科研管理系统", :string=>"易普拉格科研管理系统"} if @body=~/lan12-jingbian-hong/ || @body=~/科研管理系统，北京易普拉格科技/ 
m << { :name=>"苏亚星校园管理系统", :string=>"苏亚星校园管理系统"} if @body=~/\/ws2004\/Public\// 
m << { :name=>"trs_wcm", :string=>"trs_wcm"} if @body=~/\/wcm\/app\/js/ || @body=~/0;URL=\/wcm/ || @body=~/window\.location\.href = "\/wcm"/ || (@body=~/forum\.trs\.com\.cn/ && @body=~/wcm/) || @body=~/\/wcm" target="_blank">网站管理/ || @body=~/\/wcm" target="_blank">管理/ 
m << { :name=>"we7", :string=>"we7"} if @body=~/\/Widgets\/WidgetCollection\// 
m << { :name=>"1024cms", :string=>"1024cms"} if @body=~/Powered by 1024 CMS/ || @body=~/generator" content="1024 CMS \(c\)/ 
m << { :name=>"360webfacil_360WebManager", :string=>"360webfacil_360WebManager"} if (@body=~/publico\/template\// && @body=~/zonapie/) || @body=~/360WebManager Software/ 
m << { :name=>"6kbbs", :string=>"6kbbs"} if @body=~/Powered by 6kbbs/ || @body=~/generator" content="6KBBS/ 
m << { :name=>"Acidcat_CMS", :string=>"Acidcat_CMS"} if @body=~/Start Acidcat CMS footer information/ || @body=~/Powered by Acidcat CMS/ 
m << { :name=>"bit-service", :string=>"bit-service"} if @body=~/bit-xxzs/ || @body=~/xmlpzs\/webissue\.asp/ 
m << { :name=>"云因网上书店", :string=>"云因网上书店"} if @body=~/main\/building\.cfm/ || @body=~/href="\.\.\/css\/newscomm\.css/ 
m << { :name=>"MediaWiki", :string=>"MediaWiki"} if @body=~/generator" content="MediaWiki/ || @body=~/\/wiki\/images\/6\/64\/Favicon\.ico/ || @body=~/Powered by MediaWiki/ 
m << { :name=>"Typecho", :string=>"Typecho"} if @body=~/generator" content="Typecho/ || (@body=~/强力驱动/ && @body=~/Typecho/) 
m << { :name=>"2z project", :string=>"2z project"} if @body=~/Generator" content="2z project/ 
m << { :name=>"phpDocumentor", :string=>"phpDocumentor"} if @body=~/Generated by phpDocumentor/ 
m << { :name=>"微门户", :string=>"微门户"} if @body=~/\/tpl\/Home\/weimeng\/common\/css\// 
m << { :name=>"webEdition", :string=>"webEdition"} if @body=~/generator" content="webEdition/ 
m << { :name=>"orocrm", :string=>"orocrm"} if @body=~/\/bundles\/oroui\// 
m << { :name=>"创星伟业校园网群", :string=>"创星伟业校园网群"} if @body=~/javascripts\/float\.js/ && @body=~/vcxvcxv/ 
m << { :name=>"BoyowCMS", :string=>"BoyowCMS"} if @body=~/publish by BoyowCMS/ 
m << { :name=>"正方教务管理系统", :string=>"正方教务管理系统"} if @body=~/style\/base\/jw\.css/ 
m << { :name=>"UFIDA_NC", :string=>"UFIDA_NC"} if (@body=~/UFIDA/ && @body=~/logo\/images\//) || @body=~/logo\/images\/ufida_nc\.png/ 
m << { :name=>"phpweb", :string=>"phpweb"} if @body=~/PDV_PAGENAME/ 
m << { :name=>"地平线CMS", :string=>"地平线CMS"} if @body=~/labelOppInforStyle/ || @title=~/Powered by deep soon/ || (@body=~/search_result\.aspx/ && @body=~/frmsearch/) 
m << { :name=>"HIMS酒店云计算服务", :string=>"HIMS酒店云计算服务"} if (@body=~/GB_ROOT_DIR/ && @body=~/maincontent\.css/) || @body=~/HIMS酒店云计算服务/ 
m << { :name=>"Tipask", :string=>"Tipask"} if @body=~/content="tipask/ 
m << { :name=>"北创图书检索系统", :string=>"北创图书检索系统"} if @body=~/opac_two/ 
m << { :name=>"微普外卖点餐系统", :string=>"微普外卖点餐系统"} if @body=~/Author" content="微普外卖点餐系统/ || @body=~/Powered By 点餐系统/ || @body=~/userfiles\/shoppics\// 
m << { :name=>"逐浪zoomla", :string=>"逐浪zoomla"} if @body=~/script src="http:\/\/code\.zoomla\.cn\// || (@body=~/NodePage\.aspx/ && @body=~/Item/) || @body=~/\/style\/images\/win8_symbol_140x140\.png/ 
m << { :name=>"北京清科锐华CEMIS", :string=>"北京清科锐华CEMIS"} if @body=~/\/theme\/2009\/image/ && @body=~/login\.asp/ 
m << { :name=>"asp168欧虎", :string=>"asp168欧虎"} if @body=~/upload\/moban\/images\/style\.css/ || @body=~/default\.php?mod=article&do=detail&tid/ 
m << { :name=>"擎天电子政务", :string=>"擎天电子政务"} if @body=~/App_Themes\/1\/Style\.css/ || @body=~/window\.location = "homepages\/index\.aspx/ || @body=~/homepages\/content_page\.aspx/ 
m << { :name=>"北京阳光环球建站系统", :string=>"北京阳光环球建站系统"} if @body=~/bigSortProduct\.asp?bigid/ 
m << { :name=>"MaticsoftSNS_动软分享社区", :string=>"MaticsoftSNS_动软分享社区"} if @body=~/MaticsoftSNS/ || (@body=~/maticsoft/ && @body=~/\/Areas\/SNS\//) 
m << { :name=>"FineCMS", :string=>"FineCMS"} if @body=~/Powered by FineCMS/ || @body=~/dayrui@gmail\.com/ || @body=~/Copyright" content="FineCMS/ 
m << { :name=>"Diferior", :string=>"Diferior"} if @body=~/Powered by Diferior/ 
m << { :name=>"国家数字化学习资源中心系统", :string=>"国家数字化学习资源中心系统"} if @title=~/页面加载中,请稍候/ && @body=~/FrontEnd/ 
m << { :name=>"某通用型政府cms", :string=>"某通用型政府cms"} if @body=~/\/deptWebsiteAction\.do/ 
m << { :name=>"万户网络", :string=>"万户网络"} if @body=~/css\/css_whir\.css/ 
m << { :name=>"rcms", :string=>"rcms"} if @body=~/\/r\/cms\/www\// && @body=~/jhtml/ 
m << { :name=>"全国烟草系统", :string=>"全国烟草系统"} if @body=~/ycportal\/webpublish/ 
m << { :name=>"O2OCMS", :string=>"O2OCMS"} if @body=~/\/index\.php\/clasify\/showone\/gtitle\// 
m << { :name=>"一采通", :string=>"一采通"} if @body=~/\/custom\/GroupNewsList\.aspx?GroupId/ 
m << { :name=>"Dolphin", :string=>"Dolphin"} if @body=~/bx_css_async/ 
m << { :name=>"wecenter", :string=>"wecenter"} if @body=~/aw_template\.js/ || @body=~/WeCenter/ 
m << { :name=>"phpvod", :string=>"phpvod"} if @body=~/Powered by PHPVOD/ || @body=~/content="phpvod/ 
m << { :name=>"08cms", :string=>"08cms"} if @body=~/content="08CMS/ || @body=~/typeof\(_08cms\)/ 
m << { :name=>"tutucms", :string=>"tutucms"} if @body=~/content="TUTUCMS/ || @body=~/Powered by TUTUCMS/ || @body=~/TUTUCMS// 
m << { :name=>"八哥CMS", :string=>"八哥CMS"} if @body=~/content="BageCMS/ 
m << { :name=>"mymps", :string=>"mymps"} if @body=~/\/css\/mymps\.css/ || @title=~/mymps/ || @body=~/content="mymps/ 
m << { :name=>"IMGCms", :string=>"IMGCms"} if @body=~/content="IMGCMS/ || @body=~/Powered by IMGCMS/ 
m << { :name=>"jieqi cms", :string=>"jieqi cms"} if @body=~/content="jieqi cms/ || @title=~/jieqi cms/ 
m << { :name=>"eadmin", :string=>"eadmin"} if @body=~/content="eAdmin/ || @title=~/eadmin/ 
m << { :name=>"opencms", :string=>"opencms"} if @body=~/content="OpenCms/ || @body=~/Powered by OpenCms/ 
m << { :name=>"infoglue", :string=>"infoglue"} if @title=~/infoglue/ || @body=~/infoglueBox\.png/ 
m << { :name=>"171cms", :string=>"171cms"} if @body=~/content="171cms/ || @title=~/171cms/ 
m << { :name=>"doccms", :string=>"doccms"} if @body=~/Power by DocCms/ 
m << { :name=>"appcms", :string=>"appcms"} if @body=~/Powerd by AppCMS/ 
m << { :name=>"niucms", :string=>"niucms"} if @body=~/content="NIUCMS/ 
m << { :name=>"baocms", :string=>"baocms"} if @body=~/content="BAOCMS/ || @title=~/baocms/ 
m << { :name=>"PublicCMS", :string=>"PublicCMS"} if @title=~/publiccms/ 
m << { :name=>"JTBC(CMS)", :string=>"JTBC(CMS)"} if @body=~/\/js\/jtbc\.js/ || @body=~/content="JTBC/ 
m << { :name=>"易企CMS", :string=>"易企CMS"} if @body=~/content="YiqiCMS/ 
m << { :name=>"ZCMS", :string=>"ZCMS"} if @body=~/_ZCMS_ShowNewMessage/ || @body=~/zcms_skin/ || @title=~/ZCMS泽元内容管理/ 
m << { :name=>"科蚁CMS", :string=>"科蚁CMS"} if @body=~/keyicms：keyicms/ || @body=~/Powered by <a href="http:\/\/www\.keyicms\.com/ 
m << { :name=>"苹果CMS", :string=>"苹果CMS"} if @body=~/maccms:voddaycount/ 
m << { :name=>"大米CMS", :string=>"大米CMS"} if @title=~/大米CMS-/ || @body=~/content="damicms/ || @body=~/content="大米CMS/ 
m << { :name=>"phpmps", :string=>"phpmps"} if @body=~/Powered by Phpmps/ || @body=~/templates\/phpmps\/style\/index\.css/ 
m << { :name=>"25yi", :string=>"25yi"} if @body=~/Powered by 25yi/ || @body=~/css\/25yi\.css/ 
m << { :name=>"kingcms", :string=>"kingcms"} if @title=~/kingcms/ || @body=~/content="KingCMS/ || @body=~/Powered by KingCMS/ 
m << { :name=>"易点CMS", :string=>"易点CMS"} if @body=~/DianCMS_SiteName/ || @body=~/DianCMS_用户登陆引用/ 
m << { :name=>"fengcms", :string=>"fengcms"} if @body=~/Powered by FengCms/ || @body=~/content="FengCms/ 
m << { :name=>"phpb2b", :string=>"phpb2b"} if @body=~/Powered By PHPB2B/ 
m << { :name=>"phpdisk", :string=>"phpdisk"} if @body=~/Powered by PHPDisk/ || @body=~/content="PHPDisk/ 
m << { :name=>"EduSoho开源网络课堂", :string=>"EduSoho开源网络课堂"} if @title=~/edusoho/ || @body=~/Powered by <a href="http:\/\/www\.edusoho\.com/ || @body=~/Powered By EduSoho/ 
m << { :name=>"phpok", :string=>"phpok"} if @title=~/phpok/ || @body=~/Powered By phpok\.com/ || @body=~/content="phpok/ 
m << { :name=>"dtcms", :string=>"dtcms"} if @title=~/dtcms/ || @body=~/content="动力启航,DTCMS/ 
m << { :name=>"beecms", :string=>"beecms"} if (@body=~/powerd by/ && @body=~/BEESCMS/) || @body=~/template\/default\/images\/slides\.min\.jquery\.js/ 
m << { :name=>"ourphp", :string=>"ourphp"} if @body=~/content="OURPHP/ || @body=~/Powered by ourphp/ 
m << { :name=>"php云", :string=>"php云"} if @body=~/<div class="index_link_list_name">/ 
m << { :name=>"贷齐乐p2p", :string=>"贷齐乐p2p"} if @body=~/\/js\/jPackageCss\/jPackage\.css/ || @body=~/src="\/js\/jPackage/ 
m << { :name=>"中企动力门户CMS", :string=>"中企动力门户CMS"} if @body=~/中企动力提供技术支持/ 
m << { :name=>"destoon", :string=>"destoon"} if @body=~/<meta name="generator" content="Destoon/ || @body=~/destoon_moduleid/ 
m << { :name=>"帝友P2P", :string=>"帝友P2P"} if @body=~/\/js\/diyou\.js/ || @body=~/src="\/dyweb\/dythemes/ 
m << { :name=>"海洋CMS", :string=>"海洋CMS"} if @title=~/seacms/ || @body=~/Powered by SeaCms/ || @body=~/content="seacms/ 
m << { :name=>"合正网站群内容管理系统", :string=>"合正网站群内容管理系统"} if @body=~/Produced By/ && @body=~/网站群内容管理系统/ 
m << { :name=>"OpenSNS", :string=>"OpenSNS"} if (@body=~/powered by/ && @body=~/opensns/) || @body=~/content="OpenSNS/ 
m << { :name=>"SEMcms", :string=>"SEMcms"} if @body=~/semcms PHP/ || @body=~/sc_mid_c_left_c sc_mid_left_bt/ 
m << { :name=>"Yxcms", :string=>"Yxcms"} if @body=~/\/css\/yxcms\.css/ || @body=~/content="Yxcms/ 
m << { :name=>"NITC", :string=>"NITC"} if @body=~/NITC Web Marketing Service/ || @body=~/\/images\/nitc1\.png/ 
m << { :name=>"wuzhicms", :string=>"wuzhicms"} if @body=~/Powered by wuzhicms/ || @body=~/content="wuzhicms/ 
m << { :name=>"PHPMyWind", :string=>"PHPMyWind"} if @body=~/phpMyWind\.com All Rights Reserved/ || @body=~/content="PHPMyWind/ 
m << { :name=>"SiteEngine", :string=>"SiteEngine"} if @body=~/content="Boka SiteEngine/ 
m << { :name=>"b2bbuilder", :string=>"b2bbuilder"} if @body=~/content="B2Bbuilder/ || @body=~/translateButtonId = "B2Bbuilder/ 
m << { :name=>"农友政务系统", :string=>"农友政务系统"} if @body=~/1207044504/ 
m << { :name=>"dswjcms", :string=>"dswjcms"} if @body=~/content="Dswjcms/ || @body=~/Powered by Dswjcms/ 
m << { :name=>"FoxPHP", :string=>"FoxPHP"} if @body=~/FoxPHPScroll/ || @body=~/FoxPHP_ImList/ || @body=~/content="FoxPHP/ 
m << { :name=>"weiphp", :string=>"weiphp"} if @body=~/content="WeiPHP/ || @body=~/\/css\/weiphp\.css/ 
m << { :name=>"iWebSNS", :string=>"iWebSNS"} if @body=~/\/jooyea\/images\/sns_idea1\.jpg/ || @body=~/\/jooyea\/images\/snslogo\.gif/ 
m << { :name=>"TurboCMS", :string=>"TurboCMS"} if @body=~/Powered by TurboCMS/ || @body=~ /\/cmsapp\/zxdcADD\.jsp/ || @body=~/\/cmsapp\/count\/newstop_index\.jsp?siteid/
m << { :name=>"MoMoCMS", :string=>"MoMoCMS"} if @body=~/content="MoMoCMS/ || @body=~/Powered BY MoMoCMS/ 
m << { :name=>"Acidcat CMS", :string=>"Acidcat CMS"} if @body=~/Powered by Acidcat CMS/ || @body=~/Start Acidcat CMS footer information/ || @body=~/\/css\/admin_import\.css/ 
m << { :name=>"WP Plugin All-in-one-SEO-Pack", :string=>"WP Plugin All-in-one-SEO-Pack"} if @body=~/<!-- \/all in one seo pack -->/ 
m << { :name=>"Aardvark Topsites", :string=>"Aardvark Topsites"} if @body=~/Powered by/ && @body=~/Aardvark Topsites/ 
m << { :name=>"1024 CMS", :string=>"1024 CMS"} if @body=~/Powered by 1024 CMS/ || @body=~/content="1024 CMS/ 
m << { :name=>"68 Classifieds", :string=>"68 Classifieds"} if @body=~/powered by/ && @body=~/68 Classifieds/ 
m << { :name=>"武汉弘智科技", :string=>"武汉弘智科技"} if @body=~/研发与技术支持：武汉弘智科技有限公司/ 
m << { :name=>"北京金盘鹏图软件", :string=>"北京金盘鹏图软件"} if @body=~/SpeakIntertScarch\.aspx/ 
m << { :name=>"育友软件", :string=>"育友软件"} if @body=~/http:\/\/www\.yuysoft\.com\// && @body=~/技术支持/ 
m << { :name=>"STcms", :string=>"STcms"} if @body=~/content="STCMS/ || @body=~/DahongY<dahongy@gmail\.com>/ 
m << { :name=>"青果软件", :string=>"青果软件"} if @title=~/KINGOSOFT/ || @body=~/SetKingoEncypt\.jsp/ || @body=~/\/jkingo\.js/ 
m << { :name=>"DirCMS", :string=>"DirCMS"} if @body=~/content="DirCMS/ 
m << { :name=>"牛逼cms", :string=>"牛逼cms"} if @body=~/content="niubicms/ 
m << { :name=>"南方数据", :string=>"南方数据"} if @body=~/\/SouthidcKeFu\.js/ || @body=~/CONTENT="Copyright 2003-2015 - Southidc\.net/ || @body=~/\/Southidcj2f\.Js/ 
m << { :name=>"yidacms", :string=>"yidacms"} if @body=~/yidacms\.css/ 
m << { :name=>"bluecms", :string=>"bluecms"} if @body=~/power by bcms/ || @body=~/bcms_plugin/ 
m << { :name=>"taocms", :string=>"taocms"} if @body=~/>taoCMS</ 
m << { :name=>"Tiki-wiki CMS", :string=>"Tiki-wiki CMS"} if @body=~/jqueryTiki = new Object/ 
m << { :name=>"lepton-cms", :string=>"lepton-cms"} if @body=~/content="LEPTON-CMS/ || @body=~/Powered by LEPTON CMS/ 
m << { :name=>"euse_study", :string=>"euse_study"} if @body=~/UserInfo\/UserFP\.aspx/ 
m << { :name=>"沃科网异网同显系统", :string=>"沃科网异网同显系统"} if @body=~/沃科网/ || @title=~/异网同显系统/ 
m << { :name=>"Mixcall座席管理中心", :string=>"Mixcall座席管理中心"} if @title=~/Mixcall座席管理中心/ 
m << { :name=>"DuomiCms", :string=>"DuomiCms"} if @body=~/DuomiCms/ || @title=~/Power by DuomiCms/ 
m << { :name=>"ANECMS", :string=>"ANECMS"} if @body=~/content="Erwin Aligam - ealigam@gmail\.com/ 
m << { :name=>"Ananyoo-CMS", :string=>"Ananyoo-CMS"} if @body=~/content="http:\/\/www\.ananyoo\.com/ 
m << { :name=>"Amiro-CMS", :string=>"Amiro-CMS"} if @body=~/Powered by: Amiro CMS/ || @body=~/-= Amiro\.CMS \(c\) =-/ 
m << { :name=>"AlumniServer", :string=>"AlumniServer"} if @body=~/AlumniServerProject\.php/ || @body=~/content="Alumni/ 
m << { :name=>"AlstraSoft-EPay-Enterprise", :string=>"AlstraSoft-EPay-Enterprise"} if @body=~/Powered by EPay Enterprise/ || @body=~/\/shop\.htm?action=view/ 
m << { :name=>"AlstraSoft-AskMe", :string=>"AlstraSoft-AskMe"} if @body=~/<a href="pass_recover\.php">/ || (@body=~/Powered by/ && @body=~/http:\/\/www\.alstrasoft\.com/) 
m << { :name=>"Artiphp-CMS", :string=>"Artiphp-CMS"} if @body=~/copyright Artiphp/ 
m << { :name=>"BIGACE", :string=>"BIGACE"} if @body=~/content="BIGACE/ || @body=~/Site is running BIGACE/ 
m << { :name=>"Biromsoft-WebCam", :string=>"Biromsoft-WebCam"} if @title=~/Biromsoft WebCam/ 
m << { :name=>"BackBee", :string=>"BackBee"} if @body=~/<div id="bb5-site-wrapper>/ 
m << { :name=>"Auto-CMS", :string=>"Auto-CMS"} if @body=~/Powered by Auto CMS/ || @body=~/content="AutoCMS/ 
m << { :name=>"STAR CMS", :string=>"STAR CMS"} if @body=~/content="STARCMS/ || @body=~/<img alt="STAR CMS/ 
m << { :name=>"Zotonic", :string=>"Zotonic"} if @body=~/powered by: Zotonic/ || @body=~/\/lib\/js\/apps\/zotonic-1\.0/ 
m << { :name=>"BloofoxCMS", :string=>"BloofoxCMS"} if @body=~/content="bloofoxCMS/ || @body=~/Powered by <a href="http:\/\/www\.bloofox\.com/ 
m << { :name=>"BlognPlus", :string=>"BlognPlus"} if @body=~/Powered by/ && @body=~/href="http:\/\/www\.blogn\.org/ 
m << { :name=>"bitweaver", :string=>"bitweaver"} if @body=~/content="bitweaver/ || @body=~/href="http:\/\/www\.bitweaver\.org">Powered by/ 
m << { :name=>"ClanSphere", :string=>"ClanSphere"} if @body=~/content="ClanSphere/ || @body=~/index\.php?mod=clansphere&amp;action=about/ 
m << { :name=>"CitusCMS", :string=>"CitusCMS"} if @body=~/Powered by CitusCMS/ || @body=~/<strong>CitusCMS<\/strong>/ || @body=~/content="CitusCMS/ 
m << { :name=>"CMS-WebManager-Pro", :string=>"CMS-WebManager-Pro"} if @body=~/content="Webmanager-pro/ || @body=~/href="http:\/\/webmanager-pro\.com">Web\.Manager/ 
m << { :name=>"CMSQLite", :string=>"CMSQLite"} if @body=~/powered by CMSQLite/ || @body=~/content="www\.CMSQLite\.net/ 
m << { :name=>"CMSimple", :string=>"CMSimple"} if @body=~/Powered by CMSimple\.dk/ || @body=~/content="CMSimple/ 
m << { :name=>"CMScontrol", :string=>"CMScontrol"} if @body=~/content="CMScontrol/ 
m << { :name=>"Claroline", :string=>"Claroline"} if @body=~/target="_blank">Claroline<\/a>/ || @body=~/http:\/\/www\.claroline\.net" rel="Copyright/
m << { :name=>"Car-Portal", :string=>"Car-Portal"} if @body=~/Powered by <a href="http:\/\/www\.netartmedia\.net\/carsportal/ || @body=~/class="bodyfontwhite"><strong>&nbsp;Car Script/ 
m << { :name=>"chillyCMS", :string=>"chillyCMS"} if @body=~/powered by <a href="http:\/\/FrozenPepper\.de/ 
m << { :name=>"BoonEx-Dolphin", :string=>"BoonEx-Dolphin"} if @body=~/Powered by                    Dolphin - <a href="http:\/\/www\.boonex\.com\/products\/dolphin/ 
m << { :name=>"SilverStripe", :string=>"SilverStripe"} if @body=~/content="SilverStripe/ 
m << { :name=>"Campsite", :string=>"Campsite"} if @body=~/content="Campsite/ 
m << { :name=>"ischoolsite", :string=>"ischoolsite"} if @body=~/Powered by <a href="http:\/\/www\.ischoolsite\.com/ 
m << { :name=>"CafeEngine", :string=>"CafeEngine"} if @body=~/\/CafeEngine\/style\.css/ || @body=~/<a href=http:\/\/cafeengine\.com>CafeEngine\.com/ 
m << { :name=>"BrowserCMS", :string=>"BrowserCMS"} if @body=~/Powered by BrowserCMS/ || @body=~/content="BrowserCMS/ 
m << { :name=>"Contrexx-CMS", :string=>"Contrexx-CMS"} if @body=~/powered by Contrexx/ || @body=~/content="Contrexx/ 
m << { :name=>"ContentXXL", :string=>"ContentXXL"} if @body=~/content="contentXXL/ 
m << { :name=>"Contentteller-CMS", :string=>"Contentteller-CMS"} if @body=~/content="Esselbach Contentteller CMS/ 
m << { :name=>"Contao", :string=>"Contao"} if @body=~/system\/contao\.css/ 
m << { :name=>"CommonSpot", :string=>"CommonSpot"} if @body=~/content="CommonSpot/ 
m << { :name=>"CruxCMS", :string=>"CruxCMS"} if @body=~/Created by CruxCMS/ || @body=~/title="CruxCMS" class="blank/ 
m << { :name=>"锐商企业CMS", :string=>"锐商企业CMS"} if @body=~/href="\/Writable\/ClientImages\/mycss\.css/ 
m << { :name=>"coWiki", :string=>"coWiki"} if @body=~/content="coWiki/ || @body=~/<!-- Generated by coWiki/ 
m << { :name=>"Coppermine", :string=>"Coppermine"} if @body=~/<!--Coppermine Photo Gallery/ 
m << { :name=>"DaDaBIK", :string=>"DaDaBIK"} if @body=~/content="DaDaBIK/ || @body=~/class="powered_by_dadabik/ 
m << { :name=>"Custom-CMS", :string=>"Custom-CMS"} if @body=~/content="CustomCMS/ || @body=~/title="Powered by CCMS/ 
m << { :name=>"DT-Centrepiece", :string=>"DT-Centrepiece"} if @body=~/content="DT Centrepiece/ || @body=~/Powered By DT Centrepiece/ 
m << { :name=>"Edito-CMS", :string=>"Edito-CMS"} if @body=~/content="edito/ || @body=~/href="http:\/\/www\.edito\.pl\// 
m << { :name=>"Echo", :string=>"Echo"} if @body=~/powered by echo/ || @body=~/\/Echo2\/echoweb\/login/ 
m << { :name=>"Ecomat-CMS", :string=>"Ecomat-CMS"} if @body=~/content="ECOMAT CMS/ 
m << { :name=>"EazyCMS", :string=>"EazyCMS"} if @body=~/powered by eazyCMS/ || @body=~/<a class="actionlink" href="http:\/\/www\.eazyCMS\.com/ 
m << { :name=>"easyLink-Web-Solutions", :string=>"easyLink-Web-Solutions"} if @body=~/content="easyLink/ 
m << { :name=>"EasyConsole-CMS", :string=>"EasyConsole-CMS"} if @body=~/Powered by EasyConsole CMS/ || @body=~/Powered by <a href="http:\/\/www\.easyconsole\.com/ 
m << { :name=>"DotCMS", :string=>"DotCMS"} if @body=~/\/dotAsset\// || @body=~/\/index\.dot/ 
m << { :name=>"DBHcms", :string=>"DBHcms"} if @body=~/powered by DBHcms/ 
m << { :name=>"Donations-Cloud", :string=>"Donations-Cloud"} if @body=~/\/donationscloud\.css/ 
m << { :name=>"Dokeos", :string=>"Dokeos"} if @body=~/href="http:\/\/www\.dokeos\.com" rel="Copyright/ || @body=~/content="Dokeos/ || @body=~/name="Generator" content="Dokeos/ 
m << { :name=>"Elxis-CMS", :string=>"Elxis-CMS"} if @body=~/content="Elxis/ 
m << { :name=>"eFront", :string=>"eFront"} if @body=~/<a href = "http:\/\/www\.efrontlearning\.net/ 
m << { :name=>"eSitesBuilder", :string=>"eSitesBuilder"} if @body=~/eSitesBuilder\. All rights reserved/ 
m << { :name=>"EPiServer", :string=>"EPiServer"} if @body=~/content="EPiServer/ || @body=~/\/javascript\/episerverscriptmanager\.js/ 
m << { :name=>"Energine", :string=>"Energine"} if @body=~/scripts\/Energine\.js/ || @body=~/Powered by <a href= "http:\/\/energine\.org\// || @body=~/stylesheets\/energine\.css/ 
m << { :name=>"Gallery", :string=>"Gallery"} if @title=~/Gallery 3 Installer/ || @body=~/\/gallery\/images\/gallery\.png/ 
m << { :name=>"FrogCMS", :string=>"FrogCMS"} if @body=~/target="_blank">Frog CMS/ || @body=~/href="http:\/\/www\.madebyfrog\.com">Frog CMS/ 
m << { :name=>"Fossil", :string=>"Fossil"} if @body=~/<a href="http:\/\/fossil-scm\.org/ 
m << { :name=>"FCMS", :string=>"FCMS"} if @body=~/content="Ryan Haudenschilt/ || @body=~/Powered by Family Connections/ 
m << { :name=>"Fastpublish-CMS", :string=>"Fastpublish-CMS"} if @body=~/content="fastpublish/ 
m << { :name=>"F3Site", :string=>"F3Site"} if @body=~/Powered by <a href="http:\/\/compmaster\.prv\.pl/ 
m << { :name=>"Exponent-CMS", :string=>"Exponent-CMS"} if @body=~/content="Exponent Content Management System/ || @body=~/Powered by Exponent CMS/ 
m << { :name=>"E-Xoopport", :string=>"E-Xoopport"} if @body=~/Powered by E-Xoopport/ || @body=~/content="E-Xoopport/ 
m << { :name=>"E-Manage-MySchool", :string=>"E-Manage-MySchool"} if @body=~/E-Manage All Rights Reserved MySchool Version/ 
m << { :name=>"glFusion", :string=>"glFusion"} if @body=~/by <a href="http:\/\/www\.glfusion\.org\// 
m << { :name=>"GetSimple", :string=>"GetSimple"} if @body=~/content="GetSimple/ || @body=~/Powered by GetSimple/ 
m << { :name=>"HESK", :string=>"HESK"} if @body=~/hesk_javascript\.js/ || @body=~/hesk_style\.css/ || @body=~/Powered by <a href="http:\/\/www\.hesk\.com/ || @body=~/Powered by <a href=":\/\/www\.hesk\.com/ 
m << { :name=>"GuppY", :string=>"GuppY"} if @body=~/content="GuppY/ || @body=~/class="copyright" href="http:\/\/www\.freeguppy\.org\// 
m << { :name=>"FluentNET", :string=>"FluentNET"} if @body=~/content="Fluent/ 
m << { :name=>"GeekLog", :string=>"GeekLog"} if @body=~/Powered By <a href="http:\/\/www\.geeklog\.net\// 
m << { :name=>"Hycus-CMS", :string=>"Hycus-CMS"} if @body=~/content="Hycus/ || @body=~/Powered By <a href="http:\/\/www\.hycus\.com/ 
m << { :name=>"Hotaru-CMS", :string=>"Hotaru-CMS"} if @body=~/content="Hotaru/ 
m << { :name=>"HoloCMS", :string=>"HoloCMS"} if @body=~/Powered by HoloCMS/ 
m << { :name=>"ImpressPages-CMS", :string=>"ImpressPages-CMS"} if @body=~/content="ImpressPages CMS/ 
m << { :name=>"iGaming-CMS", :string=>"iGaming-CMS"} if @body=~/Powered by/ && @body=~/http:\/\/www\.igamingcms\.com\// 
m << { :name=>"xoops", :string=>"xoops"} if @body=~/include\/xoops\.js/ 
m << { :name=>"Intraxxion-CMS", :string=>"Intraxxion-CMS"} if @body=~/content="Intraxxion/ || @body=~/<!-- site built by Intraxxion/ 
m << { :name=>"InterRed", :string=>"InterRed"} if @body=~/content="InterRed/ || @body=~/Created with InterRed/ 
m << { :name=>"Informatics-CMS", :string=>"Informatics-CMS"} if @body=~/content="Informatics/ 
m << { :name=>"JagoanStore", :string=>"JagoanStore"} if @body=~/href="http:\/\/www\.jagoanstore\.com\/" target="_blank">Toko Online/ 
m << { :name=>"Kandidat-CMS", :string=>"Kandidat-CMS"} if @body=~/content="Kandidat-CMS/ 
m << { :name=>"Kajona", :string=>"Kajona"} if @body=~/content="Kajona/ || @body=~/powered by Kajona/ 
m << { :name=>"JGS-Portal", :string=>"JGS-Portal"} if @body=~/Powered by <b>JGS-Portal Version/ || @body=~/href="jgs_portal_box\.php?id/ 
m << { :name=>"jCore", :string=>"jCore"} if @body=~/JCORE_VERSION = / 
m << { :name=>"EdmWebVideo", :string=>"EdmWebVideo"} if @title=~/EdmWebVideo/ 
m << { :name=>"edvr", :string=>"edvr"} if @title=~/edvs\/edvr/ 
m << { :name=>"Polycom", :string=>"Polycom"} if @title=~/Polycom/ && @body=~/kAllowDirectHTMLFileAccess/ 
m << { :name=>"techbridge", :string=>"techbridge"} if @body=~/Sorry,you need to use IE brower/ 
m << { :name=>"NETSurveillance", :string=>"NETSurveillance"} if @title=~/NETSurveillance/ 
m << { :name=>"nvdvr", :string=>"nvdvr"} if @title=~/XWebPlay/ 
m << { :name=>"DVR camera", :string=>"DVR camera"} if @title=~/DVR WebClient/ 
m << { :name=>"Macrec_DVR", :string=>"Macrec_DVR"} if @title=~/Macrec DVR/ 
m << { :name=>"OnSSI_Video_Clients", :string=>"OnSSI_Video_Clients"} if @title=~/OnSSI Video Clients/ || @body=~/x-value="On-Net Surveillance Systems Inc\.// 
m << { :name=>"Linksys_SPA_Configuration ", :string=>"Linksys_SPA_Configuration "} if @title=~/Linksys SPA Configuration/ 
m << { :name=>"eagleeyescctv", :string=>"eagleeyescctv"} if @body=~/IP Surveillance for Your Life/ || @body=~/\/nobody\/loginDevice\.js/ 
m << { :name=>"海康威视iVMS", :string=>"海康威视iVMS"} if @body=~/g_szCacheTime/ && @body=~/iVMS/ 
m << { :name=>"佳能网络摄像头(Canon Network Cameras)", :string=>"佳能网络摄像头(Canon Network Cameras)"} if @body=~/\/viewer\/live\/en\/live\.html/ 
m << { :name=>"NetDvrV3", :string=>"NetDvrV3"} if @body=~/objLvrForNoIE/ 
m << { :name=>"SIEMENS IP Cameras", :string=>"SIEMENS IP Cameras"} if @title=~/SIEMENS IP Camera/ 
m << { :name=>"VideoIQ Camera", :string=>"VideoIQ Camera"} if @title=~/VideoIQ Camera Login/ 
m << { :name=>"Honeywell IP-Camera", :string=>"Honeywell IP-Camera"} if @title=~/Honeywell IP-Camera/ 
m << { :name=>"sony摄像头", :string=>"sony摄像头"} if @title=~/Sony Network Camera/ || @body=~/inquiry\.cgi?inqjs=system&inqjs=camera/ 
m << { :name=>"AJA-Video-Converter", :string=>"AJA-Video-Converter"} if @body=~/eParamID_SWVersion/ 
m << { :name=>"ACTi", :string=>"ACTi"} if @title=~/Web Configurator/ || @body=~/ACTi Corporation All Rights Reserved/ 
m << { :name=>"Samsung DVR", :string=>"Samsung DVR"} if @title=~/Samsung DVR/ 
m << { :name=>"Vicworl", :string=>"Vicworl"} if @body=~/Powered by Vicworl/ || @body=~/content="Vicworl/ || @body=~/vindex_right_d/ 
m << { :name=>"AVCON6", :string=>"AVCON6"} if @body=~/filename=AVCON6Setup\.exe/ || @title=~/AVCON6系统管理平台/  || @body=~/language_dispose\.action/ 
m << { :name=>"Axis-Network-Camera", :string=>"Axis-Network-Camera"} if @title=~/AXIS Video Server/ || @body=~/\/incl\/trash\.shtml/ 
m << { :name=>"Panasonic Network Camera", :string=>"Panasonic Network Camera"} if @body=~/MultiCameraFrame?Mode=Motion&Language/ 
m << { :name=>"BlueNet-Video", :string=>"BlueNet-Video"} if @body=~/\/cgi-bin\/client_execute\.cgi?tUD=0/ || @title=~/BlueNet Video Viewer Version/ 
m << { :name=>"ClipBucket", :string=>"ClipBucket"} if @body=~/content="ClipBucket/ || @body=~/<!-- ClipBucket/ || @body=~/<!-- Forged by ClipBucket/ || @body=~/href="http:\/\/clip-bucket\.com\/">ClipBucket/ 
m << { :name=>"ZoneMinder", :string=>"ZoneMinder"} if @body=~/ZoneMinder Login/ 
m << { :name=>"DVR-WebClient", :string=>"DVR-WebClient"} if @body=~/259F9FDF-97EA-4C59-B957-5160CAB6884E/ || @title=~/DVR-WebClient/ 
m << { :name=>"D-Link-Network-Camera", :string=>"D-Link-Network-Camera"} if @body=~/DCS-950G"\.toLowerCase\(\)/ || @title=~/DCS-5300/ 
m << { :name=>"DiBos", :string=>"DiBos"} if @title=~/DiBos - Login/ || @body=~/style\/bovisnt\.css/ 
m << { :name=>"Evo-Cam", :string=>"Evo-Cam"} if @body=~/value="evocam\.jar/ || @body=~/<applet archive="evocam\.jar/ 
m << { :name=>"Intellinet-IP-Camera", :string=>"Intellinet-IP-Camera"} if @body=~/Copyright &copy;  INTELLINET NETWORK SOLUTIONS/ || @body=~/http:\/\/www\.intellinet-network\.com\/driver\/NetCam\.exe/ 
m << { :name=>"IQeye-Netcam", :string=>"IQeye-Netcam"} if @title=~/IQEYE: Live Images/ || @body=~/content="Brian Lau, IQinVision/ || @body=~/loc = "iqeyevid\.html/ 
m << { :name=>"phpwind", :string=>"phpwind"} if @title=~/Powered by phpwind/ || @body=~/content="phpwind/ 
m << { :name=>"discuz", :string=>"discuz"} if @title=~/Powered by Discuz/ || @body=~/content="Discuz/ || (@body=~/discuz_uid/ && @body=~/portal\.php?mod=view/) || @body=~/Powered by <strong><a href="http:\/\/www\.discuz\.net/ 
m << { :name=>"6kbbs", :string=>"6kbbs"} if @body=~/Powered by 6kbbs/ || @body=~/generator" content="6KBBS/ 
m << { :name=>"IP.Board", :string=>"IP.Board"} if @body=~/ipb\.vars/ 
m << { :name=>"ThinkOX", :string=>"ThinkOX"} if @body=~/Powered By ThinkOX/ || @title=~/ThinkOX/ 
m << { :name=>"bbPress", :string=>"bbPress"} if @body=~/<!-- If you like showing off the fact that your server rocks -->/ || @body=~/is proudly powered by <a href="http:\/\/bbpress\.org/ 
m << { :name=>"BlogEngine_NET", :string=>"BlogEngine_NET"} if @body=~/pics\/blogengine\.ico/ || (@body=~/Powered by/ && @body=~/http:\/\/www\.dotnetblogengine\.net/) 
m << { :name=>"boastMachine", :string=>"boastMachine"} if @body=~/powered by boastMachine/ || @body=~/Powered by <a href="http:\/\/boastology\.com/ 
m << { :name=>"BrewBlogger", :string=>"BrewBlogger"} if @body=~/developed by <a href="http:\/\/www\.zkdigital\.com/ 
m << { :name=>"Dotclear", :string=>"Dotclear"} if @body=~/Powered by <a href="http:\/\/dotclear\.org\// 
m << { :name=>"DokuWiki", :string=>"DokuWiki"} if @body=~/powered by DokuWiki/ || @body=~/content="DokuWiki/ || @body=~/<div id="dokuwiki/ 
m << { :name=>"DeluxeBB", :string=>"DeluxeBB"} if @body=~/content="powered by DeluxeBB/ 
m << { :name=>"esoTalk", :string=>"esoTalk"} if @body=~/generated by esoTalk/ || @body=~/Powered by esoTalk/ || @body=~/\/js\/esotalk\.js/ 
m << { :name=>"Hiki", :string=>"Hiki"} if @body=~/content="Hiki/ || @body=~/\/hiki_base\.css/ || @body=~/by <a href="http:\/\/hikiwiki\.org\// 
m << { :name=>"Gossamer-Forum", :string=>"Gossamer-Forum"} if @body=~/href="gforum\.cgi?username/ || @title=~/Gossamer Forum/ 
m << { :name=>"Forest-Blog", :string=>"Forest-Blog"} if @title=~/Forest Blog/ 
m << { :name=>"FluxBB", :string=>"FluxBB"} if @body=~/Powered by <a href="http:\/\/fluxbb\.org\// 
m << { :name=>"Kampyle", :string=>"Kampyle"} if @body=~/http:\/\/cf\.kampyle\.com\/k_button\.js/ || @body=~/Start Kampyle Feedback Form Button/ 
m << { :name=>"KaiBB", :string=>"KaiBB"} if @body=~/Powered by KaiBB/ || @body=~/content="Forum powered by KaiBB/ 
m << { :name=>"fangmail", :string=>"fangmail"} if @body=~/\/fangmail\/default\/css\/em_css\.css/ 
m << { :name=>"MDaemon", :string=>"MDaemon"} if @body=~/\/WorldClient\.dll?View=Main/ 
m << { :name=>"网易企业邮箱", :string=>"网易企业邮箱"} if @body=~/frmvalidator/ && @title=~/邮箱用户登录/ 
m << { :name=>"TurboMail", :string=>"TurboMail"} if @body=~/Powered by TurboMail/ || @body=~/wzcon1 clearfix/ || @title=~/TurboMail邮件系统/ 
m << { :name=>"万网企业云邮箱", :string=>"万网企业云邮箱"} if @body=~/static\.mxhichina\.com\/images\/favicon\.ico/ 
m << { :name=>"bxemail", :string=>"bxemail"} if @title=~/百讯安全邮件系统/ || @title=~/百姓邮局/ || @body=~/请输入正确的电子邮件地址，如：abc@bxemail\.com/ 
m << { :name=>"Coremail", :string=>"Coremail"} if @title=~/\/coremail\/common\/assets/ || @title=~/Coremail邮件系统/ 
m << { :name=>"Lotus", :string=>"Lotus"} if @title=~/IBM Lotus iNotes Login/ || @body=~/iwaredir\.nsf/ 
m << { :name=>"mirapoint", :string=>"mirapoint"} if @body=~/\/wm\/mail\/login\.html/ 
m << { :name=>"U-Mail", :string=>"U-Mail"} if @body=~/<BODY LINK="White" VLINK="White" ALINK="White">/ 
m << { :name=>"Spammark邮件信息安全网关", :string=>"Spammark邮件信息安全网关"} if @title=~/Spammark邮件信息安全网关/ || @body=~/\/cgi-bin\/spammark?empty=1/ 
m << { :name=>"科信邮件系统", :string=>"科信邮件系统"} if @body=~/\/systemfunction\.pack\.js/ || @body=~/lo_computername/ 
m << { :name=>"winwebmail", :string=>"winwebmail"} if @title=~/winwebmail/ || @body=~/WinWebMail Server/  || @body=~/images\/owin\.css/ 
m << { :name=>"泰信TMailer邮件系统", :string=>"泰信TMailer邮件系统"} if @title=~/Tmailer/ || @body=~/content="Tmailer/ || @body=~/href="\/tmailer\/img\/logo\/favicon\.ico/ 
m << { :name=>"richmail", :string=>"richmail"} if @title=~/Richmail/ || @body=~/\/resource\/se\/lang\/se\/mail_zh_CN\.js/ || @body=~/content="Richmail/ 
m << { :name=>"iGENUS邮件系统", :string=>"iGENUS邮件系统"} if @body=~/Copyright by<A HREF="http:\/\/www\.igenus\.org/ || @title=~/iGENUS webmail/ 
m << { :name=>"金笛邮件系统", :string=>"金笛邮件系统"} if @body=~/\/jdwm\/cgi\/login\.cgi?login/ 
m << { :name=>"迈捷邮件系统(MagicMail)", :string=>"迈捷邮件系统(MagicMail)"} if @body=~/\/aboutus\/magicmail\.gif/ 
m << { :name=>"Atmail-WebMail", :string=>"Atmail-WebMail"} if @body=~/Powered by Atmail/ || @body=~/\/index\.php\/mail\/auth\/processlogin/ || @body=~/<input id="Mailserverinput/ 
m << { :name=>"FormMail", :string=>"FormMail"} if @body=~/\/FormMail\.pl/ || @body=~/href="http:\/\/www\.worldwidemart\.com\/scripts\/formmail\.shtml/ 
m << { :name=>"同城多用户商城", :string=>"同城多用户商城"} if @body=~/style_chaoshi/ 
m << { :name=>"iWebShop", :string=>"iWebShop"} if @body=~/\/runtime\/default\/systemjs/ 
m << { :name=>"1und1", :string=>"1und1"} if @body=~/\/shop\/catalog\/browse?sessid/ 
m << { :name=>"cart_engine", :string=>"cart_engine"} if @body=~/skins\/_common\/jscripts\.css/ 
m << { :name=>"Magento", :string=>"Magento"} if (@body=~/\/skin\/frontend\// && @body=~/BLANK_IMG/) || @body=~/Magento, Varien, E-commerce/ 
m << { :name=>"OpenCart", :string=>"OpenCart"} if @body=~/Powered By OpenCart/ || @body=~/catalog\/view\/theme/ 
m << { :name=>"hishop", :string=>"hishop"} if @body=~/hishop\.plugins\.openid/ || @body=~/Hishop development team/ 
m << { :name=>"Maticsoft_Shop_动软商城", :string=>"Maticsoft_Shop_动软商城"} if @body=~/Maticsoft Shop/ || (@body=~/maticsoft/ && @body=~/\/Areas\/Shop\//) 
m << { :name=>"hikashop", :string=>"hikashop"} if @body=~/\/media\/com_hikashop\/css\// 
m << { :name=>"tp-shop", :string=>"tp-shop"} if @body=~/mn-c-top/ 
m << { :name=>" 海盗云商(Haidao)", :string=>" 海盗云商(Haidao)"} if @body=~/haidao\.web\.general\.js/ 
m << { :name=>"shopbuilder", :string=>"shopbuilder"} if @body=~/content="ShopBuilder/ || @body=~/Powered by ShopBuilder/ || @body=~/ShopBuilder版权所有/ 
m << { :name=>"v5shop", :string=>"v5shop"} if @title=~/v5shop/ || @body=~/content="V5shop/ || @body=~/Powered by V5Shop/ 
m << { :name=>"shopnc", :string=>"shopnc"} if @body=~/Powered by ShopNC/ || @body=~/Copyright 2007-2014 ShopNC Inc/ || @body=~/content="ShopNC/ 
m << { :name=>"shopex", :string=>"shopex"} if @body=~/content="ShopEx/ || @body=~/@author litie[aita]shopex\.cn/ 
m << { :name=>"dbshop", :string=>"dbshop"} if @body=~/content="dbshop/ 
m << { :name=>"任我行电商", :string=>"任我行电商"} if @body=~/content="366EC/ 
m << { :name=>"CuuMall", :string=>"CuuMall"} if @body=~/Power by CuuMall/ 
m << { :name=>"javashop", :string=>"javashop"} if @body=~/易族智汇javashop/ || @body=~/javashop微信公众号/ || @body=~/content="JavaShop/ 
m << { :name=>"TPshop", :string=>"TPshop"} if @body=~/\/index\.php\/Mobile\/Index\/index\.html/ || @body=~/>TPshop开源商城</ 
m << { :name=>"MvMmall", :string=>"MvMmall"} if @body=~/content="MvMmall/ 
m << { :name=>"AirvaeCommerce", :string=>"AirvaeCommerce"} if @body=~/E-Commerce Shopping Cart Software/ 
m << { :name=>"AiCart", :string=>"AiCart"} if @body=~/APP_authenticate/ 
m << { :name=>"MallBuilder", :string=>"MallBuilder"} if @body=~/content="MallBuilder/ || @body=~/Powered by MallBuilder/ 
m << { :name=>"e-junkie", :string=>"e-junkie"} if @body=~/function EJEJC_lc/ 
m << { :name=>"Allomani", :string=>"Allomani"} if @body=~/content="Allomani/ || @body=~/Programmed By Allomani/ 
m << { :name=>"ASPilot-Cart", :string=>"ASPilot-Cart"} if @body=~/content="Pilot Cart/ || @body=~/\/pilot_css_default\.css/ 
m << { :name=>"Axous", :string=>"Axous"} if @body=~/content="Axous/ || @body=~/title="Axous Shareware Shop/ 
m << { :name=>"CaupoShop-Classic", :string=>"CaupoShop-Classic"} if @body=~/Powered by CaupoShop/ || @body=~/<!-- CaupoShop Classic/ || @body=~/<a href="http:\/\/www\.caupo\.net" target="_blank">CaupoNet/ 
m << { :name=>"PretsaShop", :string=>"PretsaShop"} if @body=~/content="PrestaShop// 
m << { :name=>"ComersusCart", :string=>"ComersusCart"} if @body=~/CONTENT="Powered by Comersus/ || @body=~/href="comersus_showCart\.asp/ 
m << { :name=>"Foxycart", :string=>"Foxycart"} if @body=~/<script src="\/\/cdn\.foxycart\.com/ 
m << { :name=>"DV-Cart", :string=>"DV-Cart"} if @body=~/class="KT_tngtable/ 
m << { :name=>"EarlyImpact-ProductCart", :string=>"EarlyImpact-ProductCart"} if @body=~/fpassword\.asp?redirectUrl=&frURL=Custva\.asp/ 
m << { :name=>"Escenic", :string=>"Escenic"} if @body=~/content="Escenic/ || @body=~/<!-- Start Escenic Analysis Engine client script -->/ 
m << { :name=>"ICEshop", :string=>"ICEshop"} if @body=~/Powered by ICEshop/ || @body=~/<div id="iceshop">/ 
m << { :name=>"Interspire-Shopping-Cart", :string=>"Interspire-Shopping-Cart"} if @body=~/content="Interspire Shopping Cart/ || @body=~/class="PoweredBy">Interspire Shopping Cart/ 
m << { :name=>"iScripts-MultiCart", :string=>"iScripts-MultiCart"} if @body=~/Powered by <a href="http:\/\/iscripts\.com\/multicart/ 
m << { :name=>"华天动力OA(OA8000)", :string=>"华天动力OA(OA8000)"} if @body=~/\/OAapp\/WebObjects\/OAapp\.woa/ 
m << { :name=>"通达OA", :string=>"通达OA"} if @body=~/<link rel="shortcut icon" href="\/images\/tongda\.ico" \/>/ || (@body=~/OA提示：不能登录OA/ && @body=~/紧急通知：今日10点停电/) || @body=~/Office Anywhere 2013/|| @body=~ /<a href='http:\/\/www\.tongda2000\.com\/' target='_black'>通达官网<\/a><\/div>/ 
m << { :name=>"OA(a8/seeyon/ufida)", :string=>"OA(a8/seeyon/ufida)"} if @body=~/\/seeyon\/USER-DATA\/IMAGES\/LOGIN\/login\.gif/ 
m << { :name=>"yongyoufe", :string=>"yongyoufe"} if @title=~/FE协作/ || (@body=~/V_show/ && @body=~/V_hedden/) 
m << { :name=>"pmway_E4_crm", :string=>"pmway_E4_crm"} if @title=~/E4/ && @title=~/CRM/ 
m << { :name=>"Dolibarr", :string=>"Dolibarr"} if @body=~/Dolibarr Development Team/ 
m << { :name=>"PHPOA", :string=>"PHPOA"} if @body=~/admin_img\/msg_bg\.png/ 
m << { :name=>"78oa", :string=>"78oa"} if @body=~/\/resource\/javascript\/system\/runtime\.min\.js/ || @body=~/license\.78oa\.com/ || @title=~/78oa/||@body=~/src="\/module\/index\.php/ 
m << { :name=>"WishOA", :string=>"WishOA"} if @body=~/WishOA_WebPlugin\.js/ 
m << { :name=>"金和协同管理平台", :string=>"金和协同管理平台"} if @title=~/金和协同管理平台/ 
m << { :name=>"Lotus", :string=>"Lotus"} if @title=~/IBM Lotus iNotes Login/ || @body=~/iwaredir\.nsf/ 
m << { :name=>"OA企业智能办公自动化系统", :string=>"OA企业智能办公自动化系统"} if @body=~/input name="S1" type="image/ && @body=~/count\/mystat\.asp/ 
m << { :name=>"ecwapoa", :string=>"ecwapoa"} if @body=~/ecwapoa/ 
m << { :name=>"ezOFFICE", :string=>"ezOFFICE"} if @title=~/Wanhu ezOFFICE/ || @body=~/EZOFFICEUSERNAME/ ||@title=~/万户OA/ || @body=~/whirRootPath/ || @body=~/\/defaultroot\/js\/cookie\.js/ 
m << { :name=>"任我行CRM", :string=>"任我行CRM"} if @title=~/任我行CRM/ || @body=~/CRM_LASTLOGINUSERKEY/ 
m << { :name=>"信达OA", :string=>"信达OA"} if @body=~/http:\/\/www\.xdoa\.cn<\/a>/ || @body=~/北京创信达科技有限公司/ 
m << { :name=>"协众OA", :string=>"协众OA"} if @body=~ /Powered by 协众OA/ || @body=~/admin@cnoa\.cn/ || @body=~/Powered by CNOA\.CN/ 
m << { :name=>"soffice", :string=>"soffice"} if @title=~/OA办公管理平台/ 
m << { :name=>"海天OA", :string=>"海天OA"} if @body=~/HTVOS\.js/ 
m << { :name=>"泛微OA", :string=>"泛微OA"} if @body=~/\/js\/jquery\/jquery_wev8\.js/||@body=~/\/login\/Login\.jsp?logintype=1/ 
m << { :name=>"中望OA", :string=>"中望OA"} if @body=~/\/app_qjuserinfo\/qjuserinfoadd\.jsp/ || @body=~/\/IMAGES\/default\/first\/xtoa_logo\.png/ 
m << { :name=>"睿博士云办公系统", :string=>"睿博士云办公系统"} if @body=~/\/studentSign\/toLogin\.di/ || @body=~/\/user\/toUpdatePasswordPage\.di/ 
m << { :name=>"一米OA", :string=>"一米OA"} if @body=~/\/yimioa\.apk/ 
m << { :name=>"泛普建筑工程施工OA", :string=>"泛普建筑工程施工OA"} if @body=~/\/dwr\/interface\/LoginService\.js/ 
m << { :name=>"正方OA", :string=>"正方OA"} if @body=~/zfoausername/ 
m << { :name=>"希尔OA", :string=>"希尔OA"} if @body=~/\/heeroa\/login\.do/ 
m << { :name=>"用友致远oa", :string=>"用友致远oa"} if @body=~/\/seeyon\/USER-DATA\/IMAGES\/LOGIN\/login\.gif/ || @title=~/用友致远A/ || @body=~/\/yyoa\// || @body=~/\/seeyon\/common\/all-min\.js/ 
m << { :name=>"WordPress", :string=>"WordPress"} if @body=~/\/wp-login\.php?/||@body=~/wp-user/ 
m << { :name=>"宝塔面板", :string=>"宝塔面板"} if @body=~/<title>安全入口校验失败<\/title>/ || @body=~/\/\/www\.bt\.cn\/bbs/ 
m << { :name=>"Emlog", :string=>"Emlog"} if @body=~/\/include\/lib\/js\/common_tpl\.js/&&@body=~/content\/templates/
m << { :name=>"Eyou", :string=>"Eyou"} if @body=~/亿邮电子/ || @body=~/login\.destroy\.session/
	# Return passive matches
	m
end

end

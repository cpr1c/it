&НаСервере
Процедура УстановитьТекстДокументаHTMLДляРДП()
	// Можно и так брать из строки
	РДП = 
	"<HTML>
	|	<OBJECT id=MsRdpClient classid=CLSID:3523c2fb-4031-44e4-9a3b-f1e94986ee7f width=""100%"" height=""100%"">
	|	</OBJECT>
	|</HTML>";
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("Подключение",Подключение);
	Параметры.Свойство("Логин",Логин);
	Параметры.Свойство("Пароль",Пароль);
	
	Адрес=Подключение.Адрес;
	Порт=Подключение.Порт;
	
	Заголовок=""+Подключение.Владелец+"|"+Логин;
	
	УстановитьТекстДокументаHTMLДляРДП();
КонецПроцедуры


&НаКлиенте
Процедура Подключить()
	ЭлементВК = Элементы.РДП.Документ.getElementById("MsRdpClient");
	Если ЭлементВК = Неопределено Тогда
		Сообщить("Не найден объект компоненты!");
		Возврат;
	КонецЕсли;
	
	
	RDP = ЭлементВК.contentDocument;
	//Адрес="87.244.50.254";
	//Порт=42777;
	//Логин="Администратор";
	//Пароль="848720848720Aa";
	
	//ДобавитьОбработчик RDP.OnAttendeeDisconnected, RDPOnAttendeeDisconnected; 
	
	
	RDP.server = Адрес;
	RDP.AdvancedSettings.RDPPort=Порт;
	RDP.FullScreen =  TRUE;
	
	ИнфаОбЭкранах=ПолучитьИнформациюЭкрановКлиента();

	Ширина=0;
	Высота=0;
	Для Каждого ТекМонитор Из ИнфаОбЭкранах Цикл
		Если Ширина<ТекМонитор.Ширина Тогда
			Ширина=ТекМонитор.Ширина;
			Высота=ТекМонитор.Высота;
		КонецЕсли;
	КонецЦикла;
	
	RDP.DesktopWidth = Ширина;//ИНфаОСистеме[0].Ширина;
	RDP.DesktopHeight = Высота;//ИНфаОСистеме[0].Высота;//resHeight
	//
	//MsRdpClient.Width = resWidth
	//MsRdpClient.Height = resHeight
	
	RDP.AdvancedSettings5.AuthenticationLevel = 2;       
	RDP.AdvancedSettings7.EnableCredSspSupport = TRUE;
	
	//RDP.AdvancedSettings2.RedirectDrives     = FALSE;
	RDP.AdvancedSettings2.RedirectPrinters   = Истина;
	RDP.AdvancedSettings2.RedirectPrinters   = FALSE;
	RDP.AdvancedSettings2.RedirectClipboard  = TRUE;
	RDP.AdvancedSettings2.RedirectSmartCards = FALSE;
	
	//'Set keyboard hook mode to "Always hook" - only works on XP.
	//'MsRdpClient.SecuredSettings2.KeyboardHookMode = 1
	
	//'FullScreen title
	RDP.FullScreenTitle =Заголовок;//L_FullScreenTitle_Text & "(" & serverName & ")"
	
	//'Display connect region
	//Document.all.loginArea.style.display = "none"
	//Document.all.connectArea.style.display = "block"
	//
	//'Connect
	//RDP.FullScreen=Истина;
	
	
	
	RDP.UserName=Логин;
	
	rdp.AdvancedSettings.SmartSizing = Истина;
	
	rdp.AdvancedSettings.AcceleratorPassthrough=true;
	rdp.AdvancedSettings.ClearTextPassword=Пароль;
	RDP.AdvancedSettings.ContainerHandledFullScreen=1;
	//rdp.AdvancedSettings.DisplayConnectionBar=true;
	//rdp.AdvancedSettings.GrabFocusOnConnect=true;
	//rdp.AdvancedSettings.brushSupportLevel =1;
	//rdp.AdvancedSettings.ConnectionBarShowRestoreButton = false;
	
	RDP.AdvancedSettings.containerHandledFullScreen = false;
	//RDP.AdvancedSettings.ConnectToAdministerServer = Console;
	RDP.AdvancedSettings.maxEventCount=100;
	
	RDP.StartConnected = True;
	
	RDP.Connect();
	
	
	ПодключитьОбработчикОжидания("ПроверитьПодключение",5);
КонецПроцедуры


&НаКлиенте
Процедура РДППриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры


&НаКлиенте
Процедура РДПДокументСформирован(Элемент)
	попытка
		Подключить();
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВПолножкранныйРежим(Команда)
	ЭлементВК = Элементы.РДП.Документ.getElementById("MsRdpClient");
	Если ЭлементВК = Неопределено Тогда
		Сообщить("Не найден объект компоненты!");
		Возврат;
	КонецЕсли;
	
	
	RDP = ЭлементВК.contentDocument;
	RDP.FullScreen = TRUE;
КонецПроцедуры

//
&НаКлиенте
Процедура ПроверитьПодключение()
	// Вставить содержимое обработчика.
	Попытка
		ЭлементВК = Элементы.РДП.Документ.getElementById("MsRdpClient");
		Если ЭлементВК = Неопределено Тогда
			Сообщить("Не найден объект компоненты!");
			Возврат;
		КонецЕсли;
		
		
		RDP = ЭлементВК.contentDocument;
		
		Если RDP.StartConnected=Истина
			И RDP.Connected=0 Тогда
			Закрыть();
		КонецЕсли;
		
	Исключение
	КонецПопытки;
КонецПроцедуры



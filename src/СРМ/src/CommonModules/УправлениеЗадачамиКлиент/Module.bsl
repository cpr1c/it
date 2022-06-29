Процедура ПриНачалеРаботыСистемы() Экспорт
	
	ГлобальныйПоискКлиент.ПриНачалеРаботыСистемы();
	
	ОткрыватьФормуРаботыСЗадачамиПриЗапуске = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
		"ОбщиеНастройкиПользователя", 
		"ОткрыватьФормуРаботыСЗадачамиПриЗапуске");

	Если ОткрыватьФормуРаботыСЗадачамиПриЗапуске = Истина Тогда
		ОткрытьФорму("Обработка.АРМСпециалистаПоддержки.Форма.Форма");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьТрудозатратыПоЗадаче(Задача) Экспорт
	
	Отбор=Новый Структура;
	Отбор.Вставить("Предмет",Задача);
	
	ПараметрыФормы=Новый Структура;
	ПараметрыФормы.Вставить("Отбор",Отбор);
	
	ОткрытьФорму("Документ.Трудозатраты.ФормаСписка",ПараметрыФормы,,Задача);
	
КонецПроцедуры

Процедура РедактироватьКопииПолучателейСобытияЗадачи(ТаблицаПолучателей,ОписаниеОповещения=Неопределено) Экспорт
	Если ОписаниеОповещения=Неопределено Тогда
		ДополнительныеПараметры=Новый Структура;
		ДополнительныеПараметры.Вставить("ТаблицаПолучателей",ТаблицаПолучателей);
		
		ОписаниеОповещения=Новый ОписаниеОповещения("РедактироватьКопииПолучателейСобытияЗадачиОкончание",ЭтотОбъект,ДополнительныеПараметры);
	КонецЕсли;
	
	МассивПолучателей=Новый Массив;
	
	Для каждого Стр Из ТаблицаПолучателей Цикл
		ПолучательКопии=Новый Структура("Адрес,Представление,Контакт,ВариантОтправки");
		ЗаполнитьЗначенияСвойств(ПолучательКопии,Стр);
		
		МассивПолучателей.Добавить(ПолучательКопии);
	КонецЦикла;
	
	ПараметрыФормы=Новый Структура;
	ПараметрыФормы.Вставить("Получатели",МассивПолучателей);
	
	ОткрытьФорму("ОбщаяФорма.РедакторПолучателейПочты",ПараметрыФормы,,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);	
КонецПроцедуры

Процедура РедактироватьКопииПолучателейСобытияЗадачиОкончание(Результат,ДополнительныеПараметры) Экспорт
	Если Результат=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	
	ТаблицаПолучателей=ДополнительныеПараметры.ТаблицаПолучателей;
	
	ТаблицаПолучателей.Очистить();
	
	Для Каждого Стр Из Результат ЦИкл
		НС=ТаблицаПолучателей.Добавить();
		ЗаполнитьЗначенияСвойств(НС,Стр);
	КонецЦикла;
	
//	Оповестить("ИзменилисьДопАдресаДляЭлектроннойПочты",ДополнительныеПараметры.ИдентификаторФормыИсточника);
	
КонецПроцедуры

Процедура ПолеЧасовРегулирование(Форма, ПутьКДанным, Направление, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ТекущееЗначение = Вычислить("Форма."+ПутьКДанным);
//	Квант = 0.25;
//	
//	// приводим текущее значение к точности 0.25
//	// добавляем (отнимаем) 0.25
//	// должно получиться не меньше 0.25
//	НовоеЗначение = Макс(Окр(ТекущееЗначение / Квант, 0) * Квант + Квант * Направление, Квант);
	
	ИзменитьЗначениеПоляОценкаТрудозатратПоНаправлениюРегулирования(ТекущееЗначение, Направление);
	
	Выполнить("Форма."+ПутьКДанным+ " = " + Формат(ТекущееЗначение, "ЧРД=.; ЧН=0; ЧГ=0"));
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

Процедура ИзменитьЗначениеПоляОценкаТрудозатратПоНаправлениюРегулирования(Значение, Направление) Экспорт
	Квант = 0.25;
	
	// приводим текущее значение к точности 0.25
	// добавляем (отнимаем) 0.25
	// должно получиться не меньше 0.25
	Значение = Макс(Значение + Квант * Направление, Квант);
	
КонецПроцедуры

Процедура ПолеОценкаИсполнителяРегулирование(Форма, ПутьКДанным, Направление, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Ряд = УправлениеЗадачамиКлиентСервер.РядФибоначчи();
	
	ТекущееЗначение = Вычислить("Форма."+ПутьКДанным);
	
	ТекущееЗначение = УправлениеЗадачамиКлиентСервер.ОценкаПоРядуФибоначчи(ТекущееЗначение);
	
	ИндексТекущегоЗначения = Ряд.Найти(ТекущееЗначение);
	
	Если ИндексТекущегоЗначения = Неопределено Тогда
		ИндексТекущегоЗначения = 0;
	КонецЕсли;
	
	ИндексНовогоЗначения = Макс(0, ИндексТекущегоЗначения + Направление);
	ИндексНовогоЗначения = Мин(ИндексНовогоЗначения, 99);
	
	НовоеЗначение = Ряд[ИндексНовогоЗначения];
	
	Выполнить("Форма."+ПутьКДанным+ " = " + Формат(НовоеЗначение, "ЧРД=.; ЧН=0; ЧГ=0"));
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

Процедура ОткрытьПрисоединенныйФайлПоСсылке(СсылкаНаПрисоединенныйФайл,УникальныйИдентификатор) Экспорт
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(СсылкаНаПрисоединенныйФайл, Неопределено, УникальныйИдентификатор);
	Если ДанныеФайла.Зашифрован Тогда
		// Файл может быть изменен в другом сеансе.
		ОповеститьОбИзменении(СсылкаНаПрисоединенныйФайл);
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла,Ложь);

КонецПроцедуры

Процедура ДобавитьПроектВИзбранное(Проект) Экспорт
	УправлениеЗадачами.СделатьПроектИзбранным(Проект);
	Оповестить("Проекты_ИзмениласьИзбранность");
КонецПроцедуры

Процедура УдалитьПроектИзИзбранного(Проект) Экспорт
	УправлениеЗадачами.УбратьПроектИзИзбранных(Проект);
	Оповестить("Проекты_ИзмениласьИзбранность");
КонецПроцедуры

#Область ИсторияЗадачи
Процедура ОбновитьИсториюЗадачи(Задача,ЭлементФормыИстории,Форма,ДанныеПрисоединенныхФайлов) Экспорт 
	ДанныеДляПоляИстории=УправлениеЗадачами.ДанныеЗадачиДляВыводаВПолеИстории(Задача,Форма.УникальныйИдентификатор,ДанныеПрисоединенныхФайлов);
	
	ДокументИстории=ЭлементФормыИстории.Документ.defaultView;
	
	НавигационнаяСсылкаБазы=ПолучитьНавигационнуюСсылкуИнформационнойБазы()+"/";
//	Если ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер() Тогда
//		НавигационнаяСсылкаБазы=НавигационнаяСсылкаБазы+"ru/";	
//	КонецЕсли;
	
	ДокументИстории.appTo1C.setBaseURL(НавигационнаяСсылкаБазы);
	ДокументИстории.appTo1C.history.update(ДанныеДляПоляИстории);
КонецПроцедуры

Процедура ПриНажатииПоляИсторииЗадачи(Форма, Элемент, ДанныеСобытия, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка=Ложь;

	Если СтрНачинаетсяС(ДанныеСобытия.Element.id, "Файл_") Тогда
		ИдентификаторФайла=СтрЗаменить(ДанныеСобытия.Element.id, "Файл_", "");
		СсылкаНаФайл=УправлениеЗадачами.ПолучитьСсылкуНаПрисоединенныйФайлПоИдентификатору(
			Новый УникальныйИдентификатор(ИдентификаторФайла));
		ОткрытьПрисоединенныйФайлПоСсылке(СсылкаНаФайл, Форма.УникальныйИдентификатор);
	ИначеЕсли ДанныеСобытия.Element.name="BASE_SELECTION" Тогда 
		ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(ДанныеСобытия.href);
	ИначеЕсли ЗначениеЗаполнено(ДанныеСобытия.href) Тогда
		
		ФайловаяСистемаКлиент.ЗапуститьПрограмму(ДанныеСобытия.href);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти


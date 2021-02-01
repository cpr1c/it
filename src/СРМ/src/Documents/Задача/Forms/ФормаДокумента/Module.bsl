
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	РедакторКомментария.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаСодержание,"Объект.Содержание", Объект.СодержаниеФормат);
	ТаймерыСервер.ВставитьКнопкуУправленияТаймеромНаФорму(ЭтаФорма, Элементы.ФормаКоманднаяПанель);
	
	УстановитьПараметрыДинамическихСписков();
	УстановитьОтборыДинамическихСписков();
	
	ЗаполнитьПрисоединенныеФайлы();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИсторияПоЗадаче="";
	
	ОбновитьТрудозатраты();
	УстановитьТекстПоляИстория();
	ЗаполнитьСвязанныеЗадачи();
	ЗаполнитьПодчиненныеЗадачи();
	ЗаполнитьКонтактнуюИнформациюКонтактаОбращения();
	УправлениеЗадачамиКлиентСервер.ОбновитьНадписьКоличестваДополнительныхПолучателейСообщений(Объект,Элементы.ЭлектроннаяПочтаКонтактаОбращенияКопии);
	ОбновитьТекстКоммита(ТекстКоммита, Объект.Номер, Объект.Тема);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия="ИзменилисьТрудозатраты" 
		И Параметр=Объект.Ссылка Тогда
		
		ОбновитьТрудозатраты();
		
	ИначеЕсли ИмяСобытия="ДобавленКомментарийКЗадаче"  
		И Параметр=Объект.Ссылка Тогда
		
		ЗаполнитьПрисоединенныеФайлы();
		
		ПутьКДаннымБезЛишнего=РедакторКомментарияКлиентСервер.ПолучитьПутьКДаннымБезЛишнего("Объект.Содержание",Объект.СодержаниеФормат);
		УправлениеЗадачамиКлиент.ОбновитьИсториюЗадачи(Объект.Ссылка,Элементы.ИсторияПоЗадаче,ЭтотОбъект,РедакторКомментарияКлиент.ДанныеПрисоединенныхФайлов(ЭтаФорма,ПутьКДаннымБезЛишнего,Объект.СодержаниеФормат));
		
	ИначеЕсли ИмяСобытия="ИзмененаСвязаннаяЗадача"  
		И (Параметр=Объект.Ссылка ИЛИ Источник=Объект.Ссылка)Тогда
		
		ЗаполнитьСвязанныеЗадачи();
		
	ИначеЕсли ИмяСобытия="ИзмененаЗадача" Тогда
		
		Прочитать();
		
		Если СписокПодчиненныхЗадач.НайтиПоЗначению(Параметр)<>Неопределено ИЛИ Источник=Объект.Ссылка Тогда
			ЗаполнитьПодчиненныеЗадачи();
		КонецЕсли;
		
		ПутьКДаннымБезЛишнего=РедакторКомментарияКлиентСервер.ПолучитьПутьКДаннымБезЛишнего("Объект.Содержание",Объект.СодержаниеФормат);
		УправлениеЗадачамиКлиент.ОбновитьИсториюЗадачи(Объект.Ссылка,Элементы.ИсторияПоЗадаче,ЭтотОбъект,РедакторКомментарияКлиент.ДанныеПрисоединенныхФайлов(ЭтаФорма,ПутьКДаннымБезЛишнего,Объект.СодержаниеФормат));
		
	ИначеЕсли ИмяСобытия="ИзменилисьДопАдресаДляЭлектроннойПочты" 
		И Параметр=Объект.Ссылка Тогда
		
		УправлениеЗадачамиКлиентСервер.ОбновитьНадписьКоличестваДополнительныхПолучателейСообщений(Объект,Элементы.ЭлектроннаяПочтаКонтактаОбращенияКопии);
		Модифицированность=Истина;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	РедакторКомментарияКлиент.ПередЗаписью(ЭтаФорма,"Объект.Содержание", Объект.СодержаниеФормат);
КонецПроцедуры


&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РедакторКомментария.ПриЗаписиНаСервере(ЭтаФорма, ТекущийОбъект.Ссылка, "Объект.Содержание", Объект.СодержаниеФормат, ТекущийОбъект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ИзмененаЗадача",Объект.Ссылка,Объект.РодительскаяЗадача);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РедакторКомментария.ПослеЗаписиНаСервере(ЭтаФорма,"Объект.Содержание", Объект.СодержаниеФормат);
	
	Если ЗначениеЗаполнено(ТекстНовогоКомментария) Тогда
		ДанныеЗаполнения = ДанныеЗаполненияНовогоКомментария(ТекущийОбъект, ТекстНовогоКомментария);
		НовыйКомментарийСсылка = РезультатЗаписиНовогоКомментария(ДанныеЗаполнения);
		Если ЗначениеЗаполнено(НовыйКомментарийСсылка) Тогда
			ТекстНовогоКомментария = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// ТекстНовогоКомментария намеренно не сделал сохраняемыми данными, 
	// т.к. не нужно каждый раз сохранять задачу после ввода комментария
	Если ЗначениеЗаполнено(ТекстНовогоКомментария) Тогда
		Отказ = Истина;
		ТекстПредупреждения = "Обнаружен незаписанный текст комментария к задаче";
		Если Не ЗавершениеРаботы Тогда
			ПоказатьПредупреждение(,ТекстПредупреждения);			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	РедакторКомментарияКлиент.ПриЗакрытии(ЭтаФорма, "Объект.Содержание", Объект.СодержаниеФормат);
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТрудозатратыНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	УправлениеЗадачамиКлиент.ОткрытьТрудозатратыПоЗадаче(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
	УстановитьОтборыДинамическихСписков();
КонецПроцедуры

&НаКлиенте
Процедура ГруппаЗакладкиРеквизитовПриСменеСтраницы(Элемент, ТекущаяСтраница)
	//Если ТекущаяСтраница=Элементы.ГруппаСодержание Тогда
	//	Панель=Элементы[РВ_РедакторWysiwygHTMLКлиентСервер.ПолучитьИмяЭлементаПанелиСтраницРедактированияКомментария("Объект.Содержание")];
	//	Панель.ТекущаяСтраница=Элементы[РВ_РедакторWysiwygHTMLКлиентСервер.ПолучитьИмяСтраницыПросмотраКомментария("Объект.Содержание")];
	//		
	//	РМ_Подключаемый_ПриСменеСтраницыПоляКомментария(Панель, Панель.ТекущаяСтраница);
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПоЗадачеДокументСформирован(Элемент)
	ПутьКДаннымБезЛишнего=РедакторКомментарияКлиентСервер.ПолучитьПутьКДаннымБезЛишнего("Объект.Содержание", Объект.СодержаниеФормат);
	УправлениеЗадачамиКлиент.ОбновитьИсториюЗадачи(Объект.Ссылка,Элемент,ЭтотОбъект, РедакторКомментарияКлиент.ДанныеПрисоединенныхФайлов(ЭтаФорма,ПутьКДаннымБезЛишнего, Объект.СодержаниеФормат));
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПоЗадачеПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	УправлениеЗадачамиКлиент.ПриНажатииПоляИсторииЗадачи(ЭтотОбъект,Элемент,ДанныеСобытия,СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура КонтактОбращенияПриИзменении(Элемент)
	ЗаполнитьКонтактнуюИнформациюКонтактаОбращения();
КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаКонтактаОбращенияКопииНажатие(Элемент)
	УправлениеЗадачамиКлиент.РедактироватьКопииПолучателейСобытияЗадачи(Объект,Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ОценкаТрудозатратРегулирование(Элемент, Направление, СтандартнаяОбработка)
	УправлениеЗадачамиКлиент.ПолеЧасовРегулирование(ЭтотОбъект, "Объект.ОценкаТрудозатрат", Направление, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОценкаТрудозатратИсполнителяРегулирование(Элемент, Направление, СтандартнаяОбработка)
	УправлениеЗадачамиКлиент.ПолеОценкаИсполнителяРегулирование(ЭтотОбъект, "Объект.ОценкаТрудозатратИсполнителя", Направление, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектТемаПриИзменении(Элемент)
	
	ОбновитьТекстКоммита(ТекстКоммита, Объект.Номер, Объект.Тема);
	
КонецПроцедуры

&НаКлиенте
Процедура СпринтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Проект", Объект.Проект);
	ОткрытьФорму("Документ.Спринт.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПозвонитьКонтакту(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСвязаннуюЗадачу(Команда)
	
	Результат = Неопределено;
	ОткрытьФорму("Документ.Задача.Форма.ФормаДобавленияСвязаннойЗадачи",Новый Структура,ЭтаФорма,,,, Новый ОписаниеОповещения("ДобавитьСвязаннуюЗадачуЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСвязаннуюЗадачуЗавершение(Результат1, ДополнительныеПараметры) Экспорт
	
	Результат=Результат1;
	
	Если Результат=Неопределено Тогда
		Возврат;
	КОнецЕсли;
	
	УправлениеЗадачами.ДобавитьСвязьЗадач(Объект.Ссылка,Результат.Задача,Результат.ТипСвязи);
	
	Оповестить("ИзмененаСвязаннаяЗадача",Объект.Ссылка,Результат.Задача);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПодчиненнуюЗадачу(Команда)
	
	ОткрытьФормуСозданияПодзадачи(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИСоздатьПодзадачу(Команда)
	
	Если Модифицированность Тогда
		ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
		Если Не Записать(ПараметрыЗаписи) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФормуСозданияПодзадачи(Ложь);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьКомментарий(Команда)
	
	ДанныеЗаполнения = ДанныеЗаполненияНовогоКомментария(Объект, ТекстНовогоКомментария);
	
	НовыйКомментарийСсылка = РезультатЗаписиНовогоКомментария(ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(НовыйКомментарийСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстНовогоКомментария = "";
	
	Оповестить("ДобавленКомментарийКЗадаче", Объект.Ссылка, НовыйКомментарийСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНовогоКомментария(Команда)
	
	ДанныеЗаполнения = ДанныеЗаполненияНовогоКомментария(Объект, ТекстНовогоКомментария);
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ДанныеЗаполнения);
	ОткрытьФорму("Справочник.КомментарииЗадач.ФормаОбъекта", ПараметрыФормы, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьТрудозатраты()
	Трудозатраты=УправлениеЗадачами.ПолучитьТрудозатратыПоЗадаче(ОБъект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстПоляИстория()
	ИсторияПоЗадаче=УправлениеЗадачамиПовтИсп.СформироватьТекстHTMLДляПредставленияИсторииЗадачи();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыДинамическихСписков()
	
	Партнер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Проект, "Партнер");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(КонтактныеЛицаПартнера.Отбор,
															"Владелец",
															ВидСравненияКомпоновкиДанных.Равно,
															Партнер,
															,
															Истина,
															РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ТрудозатратыПоЗадаче.Отбор,
															"Предмет",
															ВидСравненияКомпоновкиДанных.Равно,
															Объект.Ссылка,
															,
															Истина,
															РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	КонтактныеЛицаПартнера.Параметры.УстановитьЗначениеПараметра("ВидКИТелефонКонтактногоЛица",Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица);	
	КонтактныеЛицаПартнера.Параметры.УстановитьЗначениеПараметра("ВидКИemailКонтактногоЛица",Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица);	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвязанныеЗадачи()
	МассивСвязанныхЗадач=УправлениеЗадачами.ПолучитьСвязанныеЗадачи(Объект.Ссылка);
	
	МассивДобавляемыхРеквизитов=Новый Массив;
	МассивИменДобавляемыхРеквизитов=Новый Массив;
	МассивУдаляемыхРеквизитов=Новый Массив;
	
	Реквизиты=ПолучитьРеквизиты("");
	
	МассивРеквизитовСвязанныхЗадач=Новый Массив;
	МассивИменРеквизитовСвязанныхЗадач=Новый Массив;
	ДанныеСвязанныхЗадач=Новый Соответствие;
	
	ПрефикРеквизитовСвязанныхЗадач="СвязаннаяЗадача_";
	
	Для Каждого ТекРеквизит ИЗ Реквизиты Цикл
		Если СтрНайти(ТекРеквизит.Имя,ПрефикРеквизитовСвязанныхЗадач)=1  Тогда
			МассивРеквизитовСвязанныхЗадач.Добавить(ТекРеквизит);
			МассивИменРеквизитовСвязанныхЗадач.Добавить(ТекРеквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СвязаннаяЗадача ИЗ МассивСвязанныхЗадач Цикл
		ИмяРеквизита=ПрефикРеквизитовСвязанныхЗадач+СтрЗаменить(СвязаннаяЗадача.Задача.УникальныйИдентификатор(),"-","_");
		МассивИменДобавляемыхРеквизитов.Добавить(ИмяРеквизита);
		ДанныеСвязанныхЗадач.Вставить(ИмяРеквизита,СвязаннаяЗадача);
		Если МассивИменРеквизитовСвязанныхЗадач.Найти(ИмяРеквизита)<>Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Реквизит=Новый РеквизитФормы(ИмяРеквизита,Новый ОписаниеТипов("ДокументСсылка.Задача"),"",""+СвязаннаяЗадача.ТипСвязи+" с",Истина);
		МассивДобавляемыхРеквизитов.Добавить(Реквизит);
	КонецЦикла;
	
	Для Каждого ИмяРеквизита Из МассивИменРеквизитовСвязанныхЗадач Цикл
		Если МассивИменДобавляемыхРеквизитов.Найти(ИмяРеквизита)<>Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		МассивУдаляемыхРеквизитов.Добавить(ИмяРеквизита);
	КонецЦикла;
	
	ИзменитьРеквизиты(МассивДобавляемыхРеквизитов,МассивУдаляемыхРеквизитов);
	
	Для Каждого Реквизит ИЗ МассивДобавляемыхРеквизитов Цикл
		//Группа для задачи
		ОписаниеЭлемента=РаботаСФормамиСервер.НовыйОписаниеРеквизитаЭлемента();
		ОписаниеЭлемента.Имя=Реквизит.Имя+"_Группа";
		ОписаниеЭлемента.РодительЭлемента=Элементы.ГруппаСвязанныеЗадачи;
		//ОписаниеЭлемента.Заголовок="Редатирование";		
		
		ОписаниеЭлемента.Параметры.Тип=Тип("ГруппаФормы");
		ОписаниеЭлемента.Параметры.Вставить("Вид",ВидГруппыФормы.ОбычнаяГруппа);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяШирина",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяВысота",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
		//ОписаниеЭлемента.Параметры.Вставить("ЦветФона",WebЦвета.БледноБирюзовый);
		ОписаниеЭлемента.Параметры.Вставить("Отображение",ОтображениеОбычнойГруппы.Нет);
		ОписаниеЭлемента.Параметры.Вставить("Группировка",ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда);
		ОписаниеЭлемента.Параметры.Вставить("ОтображатьЗаголовок",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("РастягиватьПоВертикали",Истина);
		
		ГруппаЗадачи=РаботаСФормамиСервер.СоздатьЭлементПоОписанию(ЭтаФорма,ОписаниеЭлемента);
		
		ОписаниеЭлемента=РаботаСФормамиСервер.НовыйОписаниеРеквизитаЭлемента();
		ОписаниеЭлемента.Имя=Реквизит.Имя;
		ОписаниеЭлемента.РодительЭлемента=ГруппаЗадачи;
		//ОписаниеЭлемента.Заголовок="Редатирование";		
		
		//ОписаниеЭлемента.Параметры.Тип=Тип("ГруппаФормы");
		ОписаниеЭлемента.Параметры.Вставить("Вид",ВидПоляФормы.ПолеНадписи);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяШирина",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяВысота",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Лево);
		ОписаниеЭлемента.Параметры.Вставить("Гиперссылка",Истина);
		//ОписаниеЭлемента.Параметры.Вставить("АвтоВысотаЯчейки",Истина);
		ОписаниеЭлемента.Параметры.Вставить("РастягиватьПоВертикали",Истина);
		//ОписаниеЭлемента.Параметры.Вставить("Рамка",Истина);
		ОписаниеЭлемента.Параметры.Вставить("ВертикальноеПоложение",ВертикальноеПоложениеЭлемента.Верх);
		
		ЭлементЗадачи=РаботаСФормамиСервер.СоздатьЭлементПоОписанию(ЭтаФорма,ОписаниеЭлемента);
		//ЭлементЗадачи.ВертикальноеПоложение=ВертикальноеПоложениеЭлемента.Верх;
		//ЭлементЗадачи.Рамка=новый Рамка(ТипРамкиЭлементаУправления.Одинарная,1);
		
		//Кнопка удаления
		НовыйОписаниеКомандыКнопки=РаботаСФормамиСервер.НовыйОписаниеКомандыКнопки();
		НовыйОписаниеКомандыКнопки.Имя=Реквизит.Имя+"_Удалить";
		НовыйОписаниеКомандыКнопки.Действие="Подключаемый_УдалениеСвязаннойЗадачи";
		НовыйОписаниеКомандыКнопки.ИмяКоманды=НовыйОписаниеКомандыКнопки.Имя;
		НовыйОписаниеКомандыКнопки.Заголовок="Удалить";
		НовыйОписаниеКомандыКнопки.Картинка=БиблиотекаКартинок.УдалитьНепосредственно;
		НовыйОписаниеКомандыКнопки.РодительЭлемента=ГруппаЗадачи;
		//НовыйОписаниеКомандыКнопки.СочетаниеКлавиш=СочетаниеКлавиш;
		
		КомандаФормы=РаботаСФормамиСервер.СоздатьКомандуПоОписанию(ЭтаФорма,НовыйОписаниеКомандыКнопки);
		КомандаФормы.Отображение=ОтображениеКнопки.Картинка;
		РаботаСФормамиСервер.СоздатьКнопкуПоОписанию(ЭтаФорма,НовыйОписаниеКомандыКнопки);
		
		ЭтаФорма[Реквизит.Имя]=ДанныеСвязанныхЗадач[Реквизит.Имя].Задача;
		
	КонецЦикла;
	
	Для каждого УдаляемыйРеквизит ИЗ МассивУдаляемыхРеквизитов Цикл
		Элементы.Удалить(Элементы[УдаляемыйРеквизит+"_Группа"]);
	КонецЦикла;
	
	Элементы.ГруппаСвязанныеЗадачи.Заголовок="Связанные задачи"+?(МассивСвязанныхЗадач.Количество()=0,"","("+МассивСвязанныхЗадач.Количество()+")");
	Элементы.ГруппаСвязанныеЗадачи.ЗаголовокСвернутогоОтображения="Связанные задачи"+?(МассивСвязанныхЗадач.Количество()=0,"","("+МассивСвязанныхЗадач.Количество()+")");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодчиненныеЗадачи()
	МассивЗадач=УправлениеЗадачами.ПолучитьПодчиненныеЗадачи(Объект.Ссылка);
	
	СписокПодчиненныхЗадач.Очистить();
	Для Каждого ТекЗадача ИЗ МассивЗадач Цикл
	 	СписокПодчиненныхЗадач.Добавить(ТекЗадача);
	КонецЦикла;
	
	МассивДобавляемыхРеквизитов=Новый Массив;
	МассивИменДобавляемыхРеквизитов=Новый Массив;
	МассивУдаляемыхРеквизитов=Новый Массив;
	
	Реквизиты=ПолучитьРеквизиты("");
	
	МассивРеквизитовСвязанныхЗадач=Новый Массив;
	МассивИменРеквизитовСвязанныхЗадач=Новый Массив;
	ДанныеЗадач=Новый Соответствие;
	
	ПрефикРеквизитовСвязанныхЗадач="ПодчиненнаяЗадача_";
	
	Для Каждого ТекРеквизит ИЗ Реквизиты Цикл
		Если СтрНайти(ТекРеквизит.Имя,ПрефикРеквизитовСвязанныхЗадач)=1  Тогда
			МассивРеквизитовСвязанныхЗадач.Добавить(ТекРеквизит);
			МассивИменРеквизитовСвязанныхЗадач.Добавить(ТекРеквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого текЗадача ИЗ МассивЗадач Цикл
		ИмяРеквизита=ПрефикРеквизитовСвязанныхЗадач+СтрЗаменить(текЗадача.УникальныйИдентификатор(),"-","_");
		МассивИменДобавляемыхРеквизитов.Добавить(ИмяРеквизита);
		ДанныеЗадач.Вставить(ИмяРеквизита,текЗадача);
		Если МассивИменРеквизитовСвязанныхЗадач.Найти(ИмяРеквизита)<>Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Реквизит=Новый РеквизитФормы(ИмяРеквизита,Новый ОписаниеТипов("ДокументСсылка.Задача"),"","",Истина);
		МассивДобавляемыхРеквизитов.Добавить(Реквизит);
	КонецЦикла;
	
	Для Каждого ИмяРеквизита Из МассивИменРеквизитовСвязанныхЗадач Цикл
		Если МассивИменДобавляемыхРеквизитов.Найти(ИмяРеквизита)<>Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		МассивУдаляемыхРеквизитов.Добавить(ИмяРеквизита);
	КонецЦикла;
	
	ИзменитьРеквизиты(МассивДобавляемыхРеквизитов,МассивУдаляемыхРеквизитов);
	
	Для Каждого Реквизит ИЗ МассивДобавляемыхРеквизитов Цикл
		//Группа для задачи
		//ОписаниеЭлемента=РаботаСФормамиСервер.НовыйОписаниеРеквизитаЭлемента();
		//ОписаниеЭлемента.Имя=Реквизит.Имя+"_Группа";
		//ОписаниеЭлемента.РодительЭлемента=Элементы.ГруппаСвязанныеЗадачи;
		////ОписаниеЭлемента.Заголовок="Редатирование";		
		//
		//ОписаниеЭлемента.Параметры.Тип=Тип("ГруппаФормы");
		//ОписаниеЭлемента.Параметры.Вставить("Вид",ВидГруппыФормы.ОбычнаяГруппа);
		//ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяШирина",Ложь);
		//ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяВысота",Ложь);
		//ОписаниеЭлемента.Параметры.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
		////ОписаниеЭлемента.Параметры.Вставить("ЦветФона",WebЦвета.БледноБирюзовый);
		//ОписаниеЭлемента.Параметры.Вставить("Отображение",ОтображениеОбычнойГруппы.Нет);
		//ОписаниеЭлемента.Параметры.Вставить("Группировка",ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда);
		//ОписаниеЭлемента.Параметры.Вставить("ОтображатьЗаголовок",Ложь);
		//ОписаниеЭлемента.Параметры.Вставить("РастягиватьПоВертикали",Истина);
		//
		//ГруппаЗадачи=РаботаСФормамиСервер.СоздатьЭлементПоОписанию(ЭтаФорма,ОписаниеЭлемента);
		//
		ОписаниеЭлемента=РаботаСФормамиСервер.НовыйОписаниеРеквизитаЭлемента();
		ОписаниеЭлемента.Имя=Реквизит.Имя;
		ОписаниеЭлемента.РодительЭлемента=Элементы.ГруппаПодчиненныеЗадачи;
		//ОписаниеЭлемента.Заголовок="Редатирование";		
		
		//ОписаниеЭлемента.Параметры.Тип=Тип("ГруппаФормы");
		ОписаниеЭлемента.Параметры.Вставить("Вид",ВидПоляФормы.ПолеНадписи);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяШирина",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяВысота",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
		ОписаниеЭлемента.Параметры.Вставить("Гиперссылка",Истина);
		//ОписаниеЭлемента.Параметры.Вставить("АвтоВысотаЯчейки",Истина);
		ОписаниеЭлемента.Параметры.Вставить("РастягиватьПоВертикали",Истина);
		//ОписаниеЭлемента.Параметры.Вставить("Рамка",Истина);
		ОписаниеЭлемента.Параметры.Вставить("ВертикальноеПоложение",ВертикальноеПоложениеЭлемента.Верх);
		
		ЭлементЗадачи=РаботаСФормамиСервер.СоздатьЭлементПоОписанию(ЭтаФорма,ОписаниеЭлемента);
		//ЭлементЗадачи.ВертикальноеПоложение=ВертикальноеПоложениеЭлемента.Верх;
		//ЭлементЗадачи.Рамка=новый Рамка(ТипРамкиЭлементаУправления.Одинарная,1);
		
		////Кнопка удаления
		//НовыйОписаниеКомандыКнопки=РаботаСФормамиСервер.НовыйОписаниеКомандыКнопки();
		//НовыйОписаниеКомандыКнопки.Имя=Реквизит.Имя+"_Удалить";
		//НовыйОписаниеКомандыКнопки.Действие="Подключаемый_УдалениеСвязаннойЗадачи";
		//НовыйОписаниеКомандыКнопки.ИмяКоманды=НовыйОписаниеКомандыКнопки.Имя;
		//НовыйОписаниеКомандыКнопки.Заголовок="Удалить";
		//НовыйОписаниеКомандыКнопки.Картинка=БиблиотекаКартинок.УдалитьНепосредственно;
		//НовыйОписаниеКомандыКнопки.РодительЭлемента=ГруппаЗадачи;
		////НовыйОписаниеКомандыКнопки.СочетаниеКлавиш=СочетаниеКлавиш;
		//
		//КомандаФормы=РаботаСФормамиСервер.СоздатьКомандуПоОписанию(ЭтаФорма,НовыйОписаниеКомандыКнопки);
		//КомандаФормы.Отображение=ОтображениеКнопки.Картинка;
		//РаботаСФормамиСервер.СоздатьКнопкуПоОписанию(ЭтаФорма,НовыйОписаниеКомандыКнопки);
		
		ЭтаФорма[Реквизит.Имя]=ДанныеЗадач[Реквизит.Имя];
		
	КонецЦикла;
	
	Для каждого УдаляемыйРеквизит ИЗ МассивУдаляемыхРеквизитов Цикл
		Элементы.Удалить(Элементы[УдаляемыйРеквизит]);
	КонецЦикла;
	
	Элементы.ГруппаПодчиненныеЗадачи.Заголовок="Подчиненные задачи"+?(МассивЗадач.Количество()=0,"","("+МассивЗадач.Количество()+")");
	Элементы.ГруппаПодчиненныеЗадачи.ЗаголовокСвернутогоОтображения="Подчиненные задачи"+?(МассивЗадач.Количество()=0,"","("+МассивЗадач.Количество()+")");
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьПрисоединенныеФайлы()
	РедакторКомментария.ПрочитатьПрисоединенныеФайлы(ЭтаФорма, Объект.Ссылка, "Объект.Содержание", Объект.СодержаниеФормат);
	ПутьКДаннымБезЛишнего=РедакторКомментарияКлиентСервер.ПолучитьПутьКДаннымБезЛишнего("Объект.Содержание", Объект.СодержаниеФормат);
	ИмяТаблицыПрисоединенныхФайлов=РедакторКомментарияКлиентСервер.ИмяТаблицыПрисоединенныхФайлов(ПутьКДаннымБезЛишнего, Объект.СодержаниеФормат);
	
	МассивДобавляемыхРеквизитов=Новый Массив;
	МассивИменДобавляемыхРеквизитов=Новый Массив;
	МассивУдаляемыхРеквизитов=Новый Массив;
	
	Реквизиты=ПолучитьРеквизиты("");
	
	МассивРеквизитов=Новый Массив;
	МассивИменРеквизитов=Новый Массив;
	ДанныеПрисоединенныхФайлов=Новый Соответствие;
	
	ПрефикРеквизитов="ПрисоединенныйФайл_";
	
	Для Каждого ТекРеквизит ИЗ Реквизиты Цикл
		Если СтрНайти(ТекРеквизит.Имя,ПрефикРеквизитов)=1  Тогда
			МассивРеквизитов.Добавить(ТекРеквизит);
			МассивИменРеквизитов.Добавить(ТекРеквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ПрисоединенныйФайл ИЗ ЭтотОбъект[ИмяТаблицыПрисоединенныхФайлов] Цикл
		ИмяРеквизита=ПрефикРеквизитов+СтрЗаменить(ПрисоединенныйФайл.Ссылка.УникальныйИдентификатор(),"-","_");
		МассивИменДобавляемыхРеквизитов.Добавить(ИмяРеквизита);
		ДанныеПрисоединенныхФайлов.Вставить(ИмяРеквизита,ПрисоединенныйФайл);
		Если МассивИменРеквизитов.Найти(ИмяРеквизита)<>Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Реквизит=Новый РеквизитФормы(ИмяРеквизита,Новый ОписаниеТипов("СправочникСсылка.ЗадачаПрисоединенныеФайлы"),,""+ПрисоединенныйФайл.Ссылка.Автор+" "+ПрисоединенныйФайл.Ссылка.ДатаСоздания,Истина);
		МассивДобавляемыхРеквизитов.Добавить(Реквизит);
	КонецЦикла;
	
	Для Каждого ИмяРеквизита Из МассивИменРеквизитов Цикл
		Если МассивИменДобавляемыхРеквизитов.Найти(ИмяРеквизита)<>Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		МассивУдаляемыхРеквизитов.Добавить(ИмяРеквизита);
	КонецЦикла;
	
	ИзменитьРеквизиты(МассивДобавляемыхРеквизитов,МассивУдаляемыхРеквизитов);
	
	Для Каждого Реквизит ИЗ МассивДобавляемыхРеквизитов Цикл
		//Группа для файла
		ОписаниеЭлемента=РаботаСФормамиСервер.НовыйОписаниеРеквизитаЭлемента();
		ОписаниеЭлемента.Имя=Реквизит.Имя+"_Группа";
		ОписаниеЭлемента.РодительЭлемента=Элементы.ГруппаПрисоединенныеФайлы;
		//ОписаниеЭлемента.Заголовок="Редатирование";		
		
		ОписаниеЭлемента.Параметры.Тип=Тип("ГруппаФормы");
		ОписаниеЭлемента.Параметры.Вставить("Вид",ВидГруппыФормы.ОбычнаяГруппа);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяШирина",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяВысота",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
		//ОписаниеЭлемента.Параметры.Вставить("ЦветФона",WebЦвета.БледноБирюзовый);
		ОписаниеЭлемента.Параметры.Вставить("Отображение",ОтображениеОбычнойГруппы.Нет);
		ОписаниеЭлемента.Параметры.Вставить("Группировка",ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда);
		ОписаниеЭлемента.Параметры.Вставить("ОтображатьЗаголовок",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("РастягиватьПоВертикали",Ложь);
		
		Группа=РаботаСФормамиСервер.СоздатьЭлементПоОписанию(ЭтаФорма,ОписаниеЭлемента);
		
		ОписаниеЭлемента=РаботаСФормамиСервер.НовыйОписаниеРеквизитаЭлемента();
		ОписаниеЭлемента.Имя=Реквизит.Имя;
		ОписаниеЭлемента.РодительЭлемента=Группа;
		//ОписаниеЭлемента.Заголовок="Редатирование";		
		
		//ОписаниеЭлемента.Параметры.Тип=Тип("ГруппаФормы");
		ОписаниеЭлемента.Параметры.Вставить("Вид",ВидПоляФормы.ПолеНадписи);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяШирина",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяВысота",Ложь);
		ОписаниеЭлемента.Параметры.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Право);
		ОписаниеЭлемента.Параметры.Вставить("Гиперссылка",Истина);
		//ОписаниеЭлемента.Параметры.Вставить("АвтоВысотаЯчейки",Истина);
		ОписаниеЭлемента.Параметры.Вставить("РастягиватьПоВертикали",Истина);
		//ОписаниеЭлемента.Параметры.Вставить("Рамка",Истина);
		ОписаниеЭлемента.Параметры.Вставить("ВертикальноеПоложение",ВертикальноеПоложениеЭлемента.Верх);
		
		ОписаниеЭлемента.Действия.Вставить("Нажатие","Подключаемый_НажатиеНаСсылкуПрисоединенногоФайла");
		
		ЭлементФайла=РаботаСФормамиСервер.СоздатьЭлементПоОписанию(ЭтаФорма,ОписаниеЭлемента);
		//ЭлементЗадачи.ВертикальноеПоложение=ВертикальноеПоложениеЭлемента.Верх;
		//ЭлементЗадачи.Рамка=новый Рамка(ТипРамкиЭлементаУправления.Одинарная,1);
		
		//Кнопка удаления
		//НовыйОписаниеКомандыКнопки=РаботаСФормамиСервер.НовыйОписаниеКомандыКнопки();
		//НовыйОписаниеКомандыКнопки.Имя=Реквизит.Имя+"_Удалить";
		//НовыйОписаниеКомандыКнопки.Действие="Подключаемый_УдалениеПрисоединенногоФайла";
		//НовыйОписаниеКомандыКнопки.ИмяКоманды=НовыйОписаниеКомандыКнопки.Имя;
		//НовыйОписаниеКомандыКнопки.Заголовок="Удалить";
		//НовыйОписаниеКомандыКнопки.Картинка=БиблиотекаКартинок.УдалитьНепосредственно;
		//НовыйОписаниеКомандыКнопки.РодительЭлемента=Группа;
		//НовыйОписаниеКомандыКнопки.СочетаниеКлавиш=СочетаниеКлавиш;
		
		//КомандаФормы=РаботаСФормамиСервер.СоздатьКомандуПоОписанию(ЭтаФорма,НовыйОписаниеКомандыКнопки);
		//КомандаФормы.Отображение=ОтображениеКнопки.Картинка;
		//РаботаСФормамиСервер.СоздатьКнопкуПоОписанию(ЭтаФорма,НовыйОписаниеКомандыКнопки);
		
		ЭтаФорма[Реквизит.Имя]=ДанныеПрисоединенныхФайлов[Реквизит.Имя].Ссылка;
		
	КонецЦикла;
	
	Для каждого УдаляемыйРеквизит ИЗ МассивУдаляемыхРеквизитов Цикл
		Элементы.Удалить(Элементы[УдаляемыйРеквизит+"_Группа"]);
	КонецЦикла;
	
	Элементы.ГруппаПрисоединенныеФайлы.Заголовок="Присоединенные файлы"+?(ЭтотОбъект[ИмяТаблицыПрисоединенныхФайлов].Количество()=0,"","("+ЭтотОбъект[ИмяТаблицыПрисоединенныхФайлов].Количество()+")");
	Элементы.ГруппаПрисоединенныеФайлы.ЗаголовокСвернутогоОтображения="Присоединенные файлы"+?(ЭтотОбъект[ИмяТаблицыПрисоединенныхФайлов].Количество()=0,"","("+ЭтотОбъект[ИмяТаблицыПрисоединенныхФайлов].Количество()+")");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПодчиненнуюЗадачуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	ЗаполнитьПодчиненныеЗадачи();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКонтактнуюИнформациюКонтактаОбращения()
	АдресЭлектроннойПочтыКонтактаОбращения=УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Объект.КонтактОбращения,Справочники.ВидыКонтактнойИнформации.EMailФизическиеЛица,,Истина);
	ТелефонКонтактаОбращения=УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Объект.КонтактОбращения,Справочники.ВидыКонтактнойИнформации.ТелефонФизическогоЛица,,Истина);
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьКопийПолучателей()
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстКоммита(ТекстКоммита, Номер, Тема)
	
	ТекстКоммита = СтрШаблон("refs #%1 %2", Формат(Номер, "ЧГ=0"), Тема);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДанныеЗаполненияНовогоКомментария(Объект, ТекстНовогоКомментария)
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Задача", Объект.Ссылка);
	ДанныеЗаполнения.Вставить("ТекстСообщения", ТекстНовогоКомментария);
	ДанныеЗаполнения.Вставить("Контакт", Объект.КонтактОбращения);
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

&НаСервереБезКонтекста
Функция РезультатЗаписиНовогоКомментария(ДанныеЗаполнения)
	
	НовыйКомментарий = Справочники.КомментарииЗадач.СоздатьЭлемент();
	НовыйКомментарий.Заполнить(ДанныеЗаполнения);
	НовыйКомментарий.Записать();
	
	Возврат НовыйКомментарий.Ссылка;

КонецФункции

&НаКлиенте
Процедура ОткрытьФормуСозданияПодзадачи(ОжидатьОповещения)
	
	ПараметрыНовойЗадачи = Новый Структура;
	ПараметрыНовойЗадачи.Вставить("Основание", Объект.Ссылка);
	ПараметрыНовойЗадачи.Вставить("ОчищатьТемуПриКопировании", Истина);
	
	Если ОжидатьОповещения Тогда
		ОткрытьФорму("Документ.Задача.Форма.ФормаДокументаНовойЗадачи", 
			ПараметрыНовойЗадачи,
			ЭтаФорма,
			,
			,
			,
			Новый ОписаниеОповещения("ДобавитьПодчиненнуюЗадачуЗавершение", ЭтотОбъект),
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	Иначе
		ОткрытьФорму("Документ.Задача.Форма.ФормаДокументаНовойЗадачи",ПараметрыНовойЗадачи);	
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_УдалениеСвязаннойЗадачи(Команда)
	ИдентфикаторЗадачи=СтрЗаменить(Команда.Имя,"СвязаннаяЗадача_","");
	ИдентфикаторЗадачи=СтрЗаменить(ИдентфикаторЗадачи,"_Удалить","");
	ИдентфикаторЗадачи=СтрЗаменить(ИдентфикаторЗадачи,"_","-");
	
	СвязаннаяЗадача=УправлениеЗадачами.ПолучитьСсылкуНаЗадачуПоИдентификатору(Новый УникальныйИдентификатор(ИдентфикаторЗадачи));
	
	УправлениеЗадачами.УдалитьСвязьЗадач(Объект.Ссылка,СвязаннаяЗадача);
	
	Оповестить("ИзмененаСвязаннаяЗадача",Объект.Ссылка,СвязаннаяЗадача);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УдалениеПрисоединенногоФайла(Команда)
	//ИдентфикаторЗадачи=СтрЗаменить(Команда.Имя,"ПрисоединенныйФайл_","");
	//ИдентфикаторЗадачи=СтрЗаменить(ИдентфикаторЗадачи,"_Удалить","");
	//ИдентфикаторЗадачи=СтрЗаменить(ИдентфикаторЗадачи,"_","-");
	//
	//СвязаннаяЗадача=УправлениеЗадачами.ПолучитьСсылкуНаЗадачуПоИдентификатору(Новый УникальныйИдентификатор(ИдентфикаторЗадачи));
	//
	//УправлениеЗадачами.УдалитьСвязьЗадач(Объект.Ссылка,СвязаннаяЗадача);
	//
	//Оповестить("ИзмененаСвязаннаяЗадача",Объект.Ссылка,СвязаннаяЗадача);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуПрисоединенногоФайла(Элемент,СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	
	Идентфикатор=СтрЗаменить(Элемент.Имя,"ПрисоединенныйФайл_","");
	//Идентфикатор=СтрЗаменить(Идентфикатор,"_Удалить","");
	Идентфикатор=СтрЗаменить(Идентфикатор,"_","-");
	
	СсылкаНаФайл=УправлениеЗадачами.ПолучитьСсылкуНаПрисоединенныйФайлПоИдентификатору(Новый УникальныйИдентификатор(Идентфикатор));
	УправлениеЗадачамиКлиент.ОткрытьПрисоединенныйФайлПоСсылке(СсылкаНаФайл,УникальныйИдентификатор);
	
	
КонецПроцедуры


#Область РВ_РедакторWysiwygHTML
//@skip-warning
&НаКлиенте
Процедура РВ_РедакторWysiwyg_Подключаемый_ДокументСформированПоляРедактированияКомментария(Элемент)
	РВ_РедакторWysiwygHTMLКлиент.ДокументСформированПоляРедактированияКомментария(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РВ_РедакторWysiwyg_Подключаемый_СобытиеПолеРедактированияКомментария(Событие) Экспорт
	РВ_РедакторWysiwygHTMLКлиент.СобытиеПолеРедактированияКомментария(ЭтаФорма, Событие);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура РВ_РедакторWysiwyg_Подключаемый_ОткрытьПрисоединенныйФайл(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
//	РМ_MarkdownКлиент.ОткрытьПрисоединенныйФайл(ЭтаФорма,Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);	
КонецПроцедуры

&НаКлиенте
Процедура РВ_РедакторWysiwyg_Подключаемый_ПриДобавленииПрисоединенногоФайла(ИмяФайла, ИдентификаторФайла, ПутьКДаннымБезЛишнего) Экспорт
	РВ_РедакторWysiwyg_Подключаемый_ПриДобавленииПрисоединенногоФайлаНаСервере(ИмяФайла, ИдентификаторФайла, ПутьКДаннымБезЛишнего);
КонецПроцедуры

&НаСервере
Процедура РВ_РедакторWysiwyg_Подключаемый_ПриДобавленииПрисоединенногоФайлаНаСервере(ИмяФайла, ИдентификаторФайла,
	ПутьКДаннымБезЛишнего) Экспорт
	РВ_РедакторWysiwygHTML.ВывестиЭлементыПрисоединенногоФайлаНаФорму(ЭтотОбъект, ИмяФайла, ИдентификаторФайла,
		ПутьКДаннымБезЛишнего);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура РВ_РедакторWysiwyg_Подключаемый_УдалитьНовыйПрисоединенныйФайл(Команда)
	РВ_РедакторWysiwygHTMLКлиент.УдалитьНовыйПрисоединенныйФайл(ЭтаФорма, Команда);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура РВ_РедакторWysiwyg_Подключаемый_ОткрытьНовыйПрисоединенныйФайл(Команда)
	РВ_РедакторWysiwygHTMLКлиент.ОткрытьПрисоединенныйФайл(ЭтаФорма, Команда);
КонецПроцедуры



#КонецОбласти

#Область РМ_РедакторMarkdown
#Область Редактирование

//@skip-warning
&НаКлиенте
Процедура РМ_Подключаемый_ПриСменеСтраницыПоляКомментария(Элемент, ТекущаяСтраница)
	РМ_MarkdownКлиент.ПриСменеСтраницыПоляКомментария(ЭтаФорма, Элемент, ТекущаяСтраница);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура РМ_Подключаемый_ОбработкаКомандыПоляКомментария(Команда)
	РМ_MarkdownКлиент.ОбработкаКомандыПоляКомментария(ЭтаФорма, Команда);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура РМ_Подключаемый_ОткрытьПрисоединенныйФайл(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
//	РМ_MarkdownКлиент.ОткрытьПрисоединенныйФайл(ЭтаФорма,Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);	
КонецПроцедуры

&НаКлиенте
Процедура РМ_Подключаемый_ПриДобавленииПрисоединенногоФайла(ИмяФайла, ИдентификаторФайла, ПутьКДаннымБезЛишнего) Экспорт
	РМ_Подключаемый_ПриДобавленииПрисоединенногоФайлаНаСервере(ИмяФайла, ИдентификаторФайла, ПутьКДаннымБезЛишнего);
КонецПроцедуры

&НаСервере
Процедура РМ_Подключаемый_ПриДобавленииПрисоединенногоФайлаНаСервере(ИмяФайла, ИдентификаторФайла,
	ПутьКДаннымБезЛишнего) Экспорт
	РМ_MarkdownСервер.ВывестиЭлементыПрисоединенногоФайлаНаФорму(ЭтотОбъект, ИмяФайла, ИдентификаторФайла,
		ПутьКДаннымБезЛишнего);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура РМ_Подключаемый_УдалитьНовыйПрисоединенныйФайл(Команда)
	РМ_MarkdownКлиент.УдалитьНовыйПрисоединенныйФайл(ЭтаФорма, Команда);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура РМ_Подключаемый_ОткрытьНовыйПрисоединенныйФайл(Команда)
	РМ_MarkdownКлиент.ОткрытьПрисоединенныйФайл(ЭтаФорма, Команда);
КонецПроцедуры

#КонецОбласти

#Область Просмотр

//@skip-warning
&НаКлиенте
Процедура РМ_Подключаемый_ПриНажатииПоляПросмотраКомментария(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РМ_MarkdownКлиент.ПриНажатииПоляПросмотраКомментария(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура РМ_Подключаемый_ДокументСформированПоляПросмотраКомментария(Элемент)
	РМ_MarkdownКлиент.ДокументСформированПоляПросмотраКомментария(ЭтаФорма, Элемент);
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#КонецОбласти

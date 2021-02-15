#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.Задача);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СписокЗадач.Отбор,"Проект",ВидСравненияКомпоновкиДанных.ВИерархии,Неопределено,,Ложь,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);

	УправлениеЗадачами.УстановитьОтборыПоУмолчаниюВСпискеЗадач(ЭтотОбъект, СписокЗадач);
	
	ОтборСписокСтатусов = ПредопределенноеЗначение("Справочник.СпискиСтатусовЗадач.КВыполнению");
	ИспользоватьОтборСписокСтатусов = Истина;
	ОбновитьОтборПоСпискуСтатусов(СписокЗадач, ОтборСписокСтатусов, ИспользоватьОтборСписокСтатусов);

	ПриСозданииНастроитьРазделПодключений();
	
	СоздатьЭлементыТекущихТаймеров();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьСписокПодключений();
	ОбновитьСписокУчетныхДанных();

	УчетВремениКлиент.ПодключитьОбработчикОжиданияОбновлениеОтображенияВремени(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия="НайденПроектВГлобальномПоиске" Тогда
		
		Если Не ЗначениеЗаполнено(Параметр) Тогда
			Возврат;
		КонецЕсли;
		
		Элементы.Проекты.ТекущаяСтрока=Параметр;
		Активизировать();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменилисьТрудозатраты" Тогда
		Элементы.СписокЗадач.Обновить();	
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_УчетныеДанныеПодключений" Тогда
		УстановитьУсловноеОформлениеПодключений();
	ИначеЕсли ИмяСобытия="Запись_ИзменениеАрхивности" Тогда
		элементы.ТочкиПодключенийСписок.Обновить();
		Элементы.СписокПодключений.Обновить();
	КонецЕсли;
	
	УчетВремениКлиент.ОбработкаОповещенияФормы(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры



#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьОтборСписокСтатусовПриИзменении(Элемент)
	
	ОбновитьОтборПоСпискуСтатусов(СписокЗадач, ОтборСписокСтатусов, ИспользоватьОтборСписокСтатусов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСписокСтатусовПриИзменении(Элемент)
	
	ИспользоватьОтборСписокСтатусов = ЗначениеЗаполнено(ОтборСписокСтатусов);
	ОбновитьОтборПоСпискуСтатусов(СписокЗадач, ОтборСписокСтатусов, ИспользоватьОтборСписокСтатусов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокЗадач

&НаКлиенте
Процедура СписокЗадачПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПроект = Элементы.Проекты.ТекущаяСтрока;
	
	Если ЗначениеЗаполнено(ТекущийПроект) Тогда
		
		Отказ = Истина;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Проект", ТекущийПроект);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Документ.Задача.Форма.ФормаДокументаНовойЗадачи", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.СписокЗадач, СписокЗадач);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

//@skip-warning
&НаКлиенте
Процедура Подключаемый_УчетВремени_РеквизитТаймераПриИзменении(Элемент)
	УчетВремениКлиент.РеквизитТаймераПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_УчетВремени_ОбработатьКомандуУчетаВремени(Команда)
	УчетВремениКлиент.ОбработатьКомандуУчетаВремени(ЭтотОбъект, Команда);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_УчетВремени_ОбновитьПродолжительностьАвтоматически()
	УчетВремениКлиент.ОбновитьОтображениеВремениТаймеров(ЭтотОбъект, Элементы.ГруппаПанельДействийТаймеры);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПанелиОтбора

&НаКлиенте
Процедура ПанельОтбораПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьРабочееПространство(ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтрагентовПриАктивизацииСтроки(Элемент)
	ВыбранныйКонтрагент = Элементы.ДеревоКонтрагентов.ТекущиеДанные.Контрагент;
	Если Элементы.ДеревоКонтрагентов.ТекущиеДанные.Флаг = Ложь Тогда
		Элементы.ПанельДанныхКонтрагента.Видимость = Ложь;
		Элементы.ПанельЗадачКонтрагента.Видимость = Истина;
	Иначе
		Элементы.ПанельДанныхКонтрагента.Видимость = Истина;
		Элементы.ПанельЗадачКонтрагента.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроектыПриАктивизацииСтроки(Элемент)
	УстановитьФильтрыПоПроекту(Элементы.Проекты.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытияЭлементовПодключений

&НаКлиенте
Процедура ТочкиПодключенийСписокПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбновитьСписокПодключений",0.1,Истина);
КонецПроцедуры

&НаКлиенте
Процедура СписокПодключенийПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбновитьСписокУчетныхДанных",0.1,Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СвернутьГруппуФильтров(Команда)
	Элементы.ПанельФильтров.Видимость=Не Элементы.ПанельФильтров.Видимость;
	Если Элементы.ПанельФильтров.Видимость Тогда 
		Элементы.СвернутьГруппуФильтров.Картинка= БиблиотекаКартинок.Влево;
	Иначе
		Элементы.СвернутьГруппуФильтров.Картинка= БиблиотекаКартинок.Вправо;
	КонецЕсли;
КонецПроцедуры

#Область Подключения

&НаКлиенте
Процедура ПоказыватьАрхивТочекПодключения(Команда)
	УстановитьВыводАрхиваТочекПодключения(Не ПоказыватьАрхивТочекПодключения);
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьАрхивПодключений(Команда)
	УстановитьВыводАрхиваПодключений(Не ПоказыватьАрхивПодключений);
КонецПроцедуры

&НаКлиенте
Процедура Подключиться(Команда)
	ТекДанныеПодключений=Элементы.СписокПодключений.ТекущиеДанные;
	Если ТекДанныеПодключений=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекДанныеПодключений.ВидПодключенияБезЛогина Тогда
		УчетныеДанныеСтруктура=ЦПР_ПодключенияСервер.ПолучитьУчетныеДанныеПодключенияДляПодключенияБезЛогина(Элементы.СписокПодключений.ТекущаяСтрока);
		
		ТочкаПодключений=УчетныеДанныеСтруктура.ТочкаПодключения;
		Логин=УчетныеДанныеСтруктура.Логин;
		Пароль=УчетныеДанныеСтруктура.Пароль;
	Иначе
		ТекДанные=Элементы.СписокУчетныхДанных.ТекущиеДанные;
		Если ТекДанные=Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ТочкаПодключений=ТекДанные.ТочкаПодключения;
		Логин=ТекДанные.Логин;
		Пароль=ТекДанные.Пароль;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТочкаПодключений) Тогда
		Возврат;
	КонецЕсли;
	
	ЦПР_ПодключенияКлиент.ВыполнитьПодключение(ТочкаПодключений,Логин,Пароль);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодключениеВФайл(Команда)
	ТекДанные=Элементы.СписокУчетныхДанных.ТекущиеДанные;
	Если ТекДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЦПР_ПодключенияКлиент.ВыполнитьСохранение(ТекДанные.ТочкаПодключения,ТекДанные.Логин,ТекДанные.Пароль);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();
	
	УправлениеЗадачами.УстановитьУсловноеОформлениеСпискаЗадач(СписокЗадач);
	УстановитьУсловноеОформлениеПодключений();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРабочееПространство(ТекущаяСтраница);
	
	Для каждого ТекЭлемент Из Элементы.РабочееПространство.ПодчиненныеЭлементы Цикл
		Если ТекЭлемент.Имя <> СтрЗаменить(ТекущаяСтраница.Имя,"Страница","Панель") Тогда
			ТекЭлемент.Видимость = Ложь;
		Иначе
			ТекЭлемент.Видимость = Истина;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФильтрыПоПроекту(ТекущийПроект)
	
	МассивЭлементовОтбораПоПроекту=ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(СписокЗадач.Отбор,"Проект");
	Если МассивЭлементовОтбораПоПроекту.Количество()=0 Тогда
		Если ЗначениеЗаполнено(ТекущийПроект) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СписокЗадач.Отбор,"Проект",ВидСравненияКомпоновкиДанных.ВИерархии,ТекущийПроект,,,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		КонецЕсли;
	Иначе
		МассивЭлементовОтбораПоПроекту[0].Использование=ЗначениеЗаполнено(ТекущийПроект);
		МассивЭлементовОтбораПоПроекту[0].ПравоеЗначение=ТекущийПроект;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОтборПоСпискуСтатусов(Список, СписокСтатусов, ИспользоватьОтборПоСпискуСтатусов)
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Статус", 
		УправлениеЗадачами.СтатусыСписка(СписокСтатусов), 
		ВидСравненияКомпоновкиДанных.ВСписке,
		, 
		ИспользоватьОтборПоСпискуСтатусов,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

#Область Подключения

&НаСервере
Процедура ПриСозданииНастроитьРазделПодключений()
	УстановитьНастройкиСпискаТочекПодключений();
	УстановитьВыводАрхиваТочекПодключения(Ложь);
	УстановитьВыводАрхиваПодключений(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиСпискаТочекПодключений()
	//Настраиваем группировку правильную
	ТочкиПодключенийСписок.Группировка.Элементы.Очистить();
	
	НоваяГруппировка=ТочкиПодключенийСписок.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	НоваяГруппировка.Использование=Истина;
	НоваяГруппировка.Поле=Новый ПолеКомпоновкиДанных("Партнер");
	НоваяГруппировка.ТипГруппировки=ТипГруппировкиКомпоновкиДанных.Элементы;
	
	НоваяГруппировка=ТочкиПодключенийСписок.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	НоваяГруппировка.Использование=Истина;
	НоваяГруппировка.Поле=Новый ПолеКомпоновкиДанных("Местоположение");
	НоваяГруппировка.ТипГруппировки=ТипГруппировкиКомпоновкиДанных.Иерархия;
	
	
	ВариантНачальногоОтображенияСпискаТочекПодключений=ЦПР_ПодключенияСервер.ПолучитьВариантНачальногоОтображенияСписка();
	Если ВариантНачальногоОтображенияСпискаТочекПодключений=Перечисления.ЦПР_ВариантыНачальногоОтображенияДерева.НеРаскрывать Тогда
		Элементы.ТочкиПодключенийСписок.НачальноеОтображениеДерева=НачальноеОтображениеДерева.НеРаскрывать;
	ИначеЕсли ВариантНачальногоОтображенияСпискаТочекПодключений=Перечисления.ЦПР_ВариантыНачальногоОтображенияДерева.РаскрыватьВсеУровни Тогда
		Элементы.ТочкиПодключенийСписок.НачальноеОтображениеДерева=НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	Иначе
		Элементы.ТочкиПодключенийСписок.НачальноеОтображениеДерева=НачальноеОтображениеДерева.РаскрыватьВерхнийУровень;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеПодключений()
	Справочники.ЦПР_ТочкиПодключения.УстановитьОформлениеСписка(ТочкиПодключенийСписок);
	Справочники.ЦПР_Подключения.УстановитьОформлениеСписка(СписокПодключений);
	РегистрыСведений.ЦПР_УчетныеДанныеПодключений.УстановитьОформлениеСписка(СписокУчетныхДанных);
КонецПроцедуры

&НаСервере
Процедура УстановитьВыводАрхиваТочекПодключения(Показывать)
	ПоказыватьАрхивТочекПодключения=Показывать;
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ТочкиПодключенийСписок,"Архив");
	
	Если Не ПоказыватьАрхивТочекПодключения Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ТочкиПодключенийСписок,"Архив",Ложь);
	КонецЕсли;
	
	Элементы.СписокПоказыватьАрхивТочекПодключения.Пометка=ПоказыватьАрхивТочекПодключения;
КонецПроцедуры

&НаСервере
Процедура УстановитьВыводАрхиваПодключений(Показывать)
	ПоказыватьАрхивПодключений=Показывать;

	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокПодключений,"Архив");
	
	Если Не ПоказыватьАрхивПодключений Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПодключений,"Архив",Ложь);
	КонецЕсли;
	
	Элементы.СписокПодключенийПоказыватьАрхивПодключений.Пометка=ПоказыватьАрхивПодключений;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокПодключений()
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокПодключений,"Владелец");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокПодключений,"Владелец.Партнер");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокПодключений,"Владелец.Местоположение");
	
	ТекСтрока=Элементы.ТочкиПодключенийСписок.ТекущаяСтрока;
	ИмяПоляОтбора = "Владелец";
	ЗначениеОтбора = ПредопределенноеЗначение("Справочник.ЦПР_ТочкиПодключения.ПустаяСсылка");
	
	Если ТекСтрока <> Неопределено Тогда
		
		Если ТипЗнч(ТекСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда	
			
			Если ТекСтрока.ИмяГруппировки = "Партнер" Тогда
				ИмяПоляОтбора = "Владелец.Партнер";
				ЗначениеОтбора = ТекСтрока.Ключ;
			ИначеЕсли ТекСтрока.ИмяГруппировки = "Местоположение" Тогда
				Если ЗначениеЗаполнено(ТекСтрока.Ключ) Тогда
					ИмяПоляОтбора = "Владелец.Местоположение";
					ЗначениеОтбора = ТекСтрока.Ключ;
				Иначе 
					ИмяПоляОтбора = "Владелец.Партнер";
					ЗначениеОтбора = ТекСтрока.РодительскаяГруппировка.Ключ;
				КонецЕсли;	
			КонецЕсли;
			
		Иначе
			
			ЗначениеОтбора = ТекСтрока;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПодключений,ИмяПоляОтбора,ЗначениеОтбора,ВидСравненияКомпоновкиДанных.Равно,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

&НаКлиенте 
Процедура ОбновитьСписокУчетныхДанных()
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокУчетныхДанных,"Владелец");
	
	ТекСтрока=Элементы.СписокПодключений.ТекущаяСтрока;
	Если ТекСтрока=Неопределено Тогда
		ТекСтрока=ПредопределенноеЗначение("Справочник.ЦПР_Подключения.ПустаяСсылка");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокУчетныхДанных,"ТочкаПодключения",ТекСтрока,ВидСравненияКомпоновкиДанных.Равно,,Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
	ТекДанные=Элементы.СписокПодключений.ТекущиеДанные;
	Если ТекДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекДанные.ВидПодключенияБезЛогина Тогда
		Элементы.ГруппаСтраницыУчетныеДанные.ТекущаяСтраница=Элементы.ГруппаУчетныеДанныеБезЛогина;
	Иначе
		Элементы.ГруппаСтраницыУчетныеДанные.ТекущаяСтраница=Элементы.ГруппаМножественныеУчетныДанные;
	КонецЕсли;
КонецПроцедуры



#КонецОбласти

#Область Таймеры

&НаСервере
Процедура СоздатьЭлементыТекущихТаймеров()
	УчетВремени.СоздатьЭлементыТекущихТаймеровНаФорме(ЭтотОбъект, Элементы.ГруппаПанельДействийТаймеры);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УчетВремени_ОбновитьЭлементыТаймеров() Экспорт
	СоздатьЭлементыТекущихТаймеров();
КонецПроцедуры
#КонецОбласти

#КонецОбласти




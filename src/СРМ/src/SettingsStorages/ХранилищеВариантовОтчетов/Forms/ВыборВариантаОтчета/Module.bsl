///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
	
	КлючВарианта = Параметры.КлючТекущихНастроек;
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	
	ОтчетИнформация = ВариантыОтчетов.СформироватьИнформациюОбОтчетеПоПолномуИмени(Параметры.КлючОбъекта);
	Если ТипЗнч(ОтчетИнформация.ТекстОшибки) = Тип("Строка") Тогда
		ВызватьИсключение ОтчетИнформация.ТекстОшибки;
	КонецЕсли;
	ОтчетИнформация.Удалить("ОтчетМетаданные");
	ОтчетИнформация.Удалить("ТекстОшибки");
	ОтчетИнформация.Вставить("ОтчетПолноеИмя", Параметры.КлючОбъекта);
	ОтчетИнформация = Новый ФиксированнаяСтруктура(ОтчетИнформация);
	
	ПолныеПраваНаВарианты = ВариантыОтчетов.ПолныеПраваНаВарианты();
	
	Если Не ПолныеПраваНаВарианты Тогда
		Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторов.Видимость = Ложь;
		Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторовКМ.Видимость = Ложь;
		ПоказыватьЛичныеВариантыОтчетовДругихАвторов = Ложь;
	КонецЕсли;
	
	ЗаполнитьСписокВариантов();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	Показывать = Настройки.Получить("ПоказыватьЛичныеВариантыОтчетовДругихАвторов");
	Если Показывать <> ПоказыватьЛичныеВариантыОтчетовДругихАвторов Тогда
		ПоказыватьЛичныеВариантыОтчетовДругихАвторов = Показывать;
		Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторов.Пометка = Показывать;
		Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторовКМ.Пометка = Показывать;
		ЗаполнитьСписокВариантов();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = ВариантыОтчетовКлиент.ИмяСобытияИзменениеВарианта()
		Или ИмяСобытия = "Запись_НаборКонстант" Тогда
		ЗаполнитьСписокВариантов();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборАвторПриИзменении(Элемент)
	ОтборВключен = ЗначениеЗаполнено(ОтборАвтор);
	
	ГруппыИлиВарианты = ДеревоВариантовОтчета.ПолучитьЭлементы();
	Для Каждого ГруппаИлиВариант Из ГруппыИлиВарианты Цикл
		ЕстьВключенные = Неопределено;
		ВложенныеВарианты = ГруппаИлиВариант.ПолучитьЭлементы();
		Для Каждого Вариант Из ВложенныеВарианты Цикл
			Вариант.СкрытОтбором = ОтборВключен И Вариант.Автор <> ОтборАвтор;
			Если Не Вариант.СкрытОтбором Тогда
				ЕстьВключенные = Истина;
			ИначеЕсли ЕстьВключенные = Неопределено Тогда
				ЕстьВключенные = Ложь;
			КонецЕсли;
		КонецЦикла;
		Если ЕстьВключенные = Неопределено Тогда // Группа это вариант.
			ГруппаИлиВариант.СкрытОтбором = ОтборВключен И ГруппаИлиВариант.Автор <> ОтборАвтор;
		Иначе // Это группа.
			ГруппаИлиВариант.СкрытОтбором = ЕстьВключенные;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоВариантовОтчета

&НаКлиенте
Процедура ДеревоВариантовОтчетаПриАктивизацииСтроки(Элемент)
	Вариант = Элементы.ДеревоВариантовОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Вариант.КлючВарианта) Тогда
		ВариантОписание = "";
	Иначе
		ВариантОписание = Вариант.Описание;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ОткрытьВариантДляИзменения();
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	
	Вариант = Элементы.ДеревоВариантовОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Или Не ЗначениеЗаполнено(Вариант.КлючВарианта) Тогда
		Возврат;
	КонецЕсли;
	
	Если Вариант.ИндексКартинки = 4 Тогда
		ТекстВопроса = НСтр("ru = 'Снять с ""%1"" пометку на удаление?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Пометить ""%1"" на удаление?'");
	КонецЕсли;
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Вариант.Наименование);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Вариант", Вариант);
	Обработчик = Новый ОписаниеОповещения("ДеревоВариантовОтчетаПередУдалениемЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьИЗакрыть();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьЛичныеВариантыОтчетовДругихАвторов(Команда)
	ПоказыватьЛичныеВариантыОтчетовДругихАвторов = Не ПоказыватьЛичныеВариантыОтчетовДругихАвторов;
	Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторов.Пометка = ПоказыватьЛичныеВариантыОтчетовДругихАвторов;
	Элементы.ПоказыватьЛичныеВариантыОтчетовДругихАвторовКМ.Пометка = ПоказыватьЛичныеВариантыОтчетовДругихАвторов;
	
	ЗаполнитьСписокВариантов();
	
	Для Каждого ГруппаДерева Из ДеревоВариантовОтчета.ПолучитьЭлементы() Цикл
		Если ГруппаДерева.СкрытОтбором = Ложь Тогда
			Элементы.ДеревоВариантовОтчета.Развернуть(ГруппаДерева.ПолучитьИдентификатор(), Истина);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьСписокВариантов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовОтчета.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовОтчетаПредставление.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовОтчетаАвтор.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоВариантовОтчета.СкрытОтбором");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовОтчетаПредставление.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовОтчетаАвтор.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоВариантовОтчета.АвторТекущийПользователь");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.МоиВариантыОтчетовЦвет);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть()
	Вариант = Элементы.ДеревоВариантовОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Вариант.КлючВарианта) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("КлючВарианта", Вариант.КлючВарианта);
	Если Вариант.ИндексКартинки = 4 Тогда
		ТекстВопроса = НСтр("ru = 'Выбранный вариант отчета помечен на удаление.
		|Выбрать этот варианта отчета?'");
		Обработчик = Новый ОписаниеОповещения("ВыбратьИЗакрытьЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ВыбратьИЗакрытьЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрытьЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Закрыть(Новый ВыборНастроек(ДополнительныеПараметры.КлючВарианта));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВариантДляИзменения()
	Вариант = Элементы.ДеревоВариантовОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Или Не ЗначениеЗаполнено(Вариант.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	Если Не ПравоИзмененияВарианта(Вариант, ПолныеПраваНаВарианты) Тогда
		ТекстПредупреждения = НСтр("ru = 'Недостаточно прав для изменения варианта ""%1"".'");
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, Вариант.Наименование);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	ВариантыОтчетовКлиент.ПоказатьНастройкиОтчета(Вариант.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовОтчетаПередУдалениемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		УдалитьВариантНаСервере(ДополнительныеПараметры.Вариант.Ссылка, ДополнительныеПараметры.Вариант.ИндексКартинки);
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПравоИзмененияВарианта(Вариант, ПолныеПраваНаВарианты)
	Возврат ПолныеПраваНаВарианты Или Вариант.АвторТекущийПользователь;
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокВариантов()
	
	ТекущийКлючВарианта = КлючВарианта;
	Если ЗначениеЗаполнено(Элементы.ДеревоВариантовОтчета.ТекущаяСтрока) Тогда
		ТекущаяСтрокаДерева = ДеревоВариантовОтчета.НайтиПоИдентификатору(Элементы.ДеревоВариантовОтчета.ТекущаяСтрока);
		Если ЗначениеЗаполнено(ТекущаяСтрокаДерева.КлючВарианта) Тогда
			ТекущийКлючВарианта = ТекущаяСтрокаДерева.КлючВарианта;
		КонецЕсли;
	КонецЕсли;
	
	ОтборОтчеты = Новый Массив;
	ОтборОтчеты.Добавить(ОтчетИнформация.Отчет);
	ПараметрыПоиска = Новый Структура("Отчеты,ПометкаУдаления,ТолькоЛичные", 
		ОтборОтчеты, Ложь, Не ПоказыватьЛичныеВариантыОтчетовДругихАвторов);
	ТаблицаВариантов = ВариантыОтчетов.ТаблицаВариантовОтчетов(ПараметрыПоиска);
	
	// Заполнить автовычисляемые колонки
	ТаблицаВариантов.Колонки.Добавить("АвторТекущийПользователь", Новый ОписаниеТипов("Булево"));	
	ТаблицаВариантов.Колонки.Добавить("ИндексКартинки", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(1, 0, ДопустимыйЗнак.Любой)));	
	ТаблицаВариантов.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(1, 0, ДопустимыйЗнак.Любой)));	
	Для каждого Вариант Из ТаблицаВариантов Цикл
		Вариант.АвторТекущийПользователь = (Вариант.Автор = ТекущийПользователь);
		Вариант.ИндексКартинки = ?(Вариант.ПометкаУдаления, 4, ?(Вариант.Пользовательский, 3, 5));
		Вариант.Порядок = ?(Вариант.ПометкаУдаления, 3, 1);
	КонецЦикла;

	Если ОтчетИнформация.ТипОтчета = Перечисления.ТипыОтчетов.Внешний 
		И Не ХранилищаНастроек.ХранилищеВариантовОтчетов.ДобавитьВариантыВнешнегоОтчета(
			ТаблицаВариантов, ОтчетИнформация.ОтчетПолноеИмя, ОтчетИнформация.ОтчетИмя) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаВариантов.Сортировать("Порядок ВОЗР, Наименование ВОЗР");
	ДеревоВариантовОтчета.ПолучитьЭлементы().Очистить();
	ГруппыДерева = Новый Соответствие;
	ГруппыДерева.Вставить(1, ДеревоВариантовОтчета.ПолучитьЭлементы());
	
	Для Каждого СведенияОВарианте Из ТаблицаВариантов Цикл
		Если Не ЗначениеЗаполнено(СведенияОВарианте.КлючВарианта) Тогда
			Продолжить;
		КонецЕсли;
		НаборСтрокДерева = ГруппыДерева.Получить(СведенияОВарианте.Порядок);
		Если НаборСтрокДерева = Неопределено Тогда
			ГруппаДерева = ДеревоВариантовОтчета.ПолучитьЭлементы().Добавить();
			ГруппаДерева.НомерГруппы = СведенияОВарианте.Порядок;
			Если СведенияОВарианте.Порядок = 3 Тогда
				ГруппаДерева.Наименование = НСтр("ru = 'Помеченные на удаление'");
				ГруппаДерева.ИндексКартинки = 1;
				ГруппаДерева.КартинкаАвтора = -1;
			КонецЕсли;
			НаборСтрокДерева = ГруппаДерева.ПолучитьЭлементы();
			ГруппыДерева.Вставить(СведенияОВарианте.Порядок, НаборСтрокДерева);
		КонецЕсли;
		
		Вариант = НаборСтрокДерева.Добавить();
		ЗаполнитьЗначенияСвойств(Вариант, СведенияОВарианте);
		Вариант.НомерГруппы = СведенияОВарианте.Порядок;
		Если Вариант.КлючВарианта = ТекущийКлючВарианта Тогда
			Элементы.ДеревоВариантовОтчета.ТекущаяСтрока = Вариант.ПолучитьИдентификатор();
		КонецЕсли;
		Вариант.КартинкаАвтора = ?(Вариант.ТолькоДляАвтора, -1, 0);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьВариантНаСервере(ВариантыОтчетовСсылка, ИндексКартинки)
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ВариантыОтчетов");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ВариантыОтчетовСсылка);
		Блокировка.Заблокировать();
		
		ВариантОбъект = ВариантыОтчетовСсылка.ПолучитьОбъект();
		ПометкаУдаления = Не ВариантОбъект.ПометкаУдаления;
		Пользовательский = ВариантОбъект.Пользовательский;
		ВариантОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;	
	ИндексКартинки = ?(ПометкаУдаления, 4, ?(Пользовательский, 3, 5));
	
КонецПроцедуры

#КонецОбласти

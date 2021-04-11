#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	РедакторКомментария.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаТекстСообщения, "Объект.ТекстСообщения",
		Объект.ТекстСообщенияФормат);

	РедакторКомментария.ПрочитатьПрисоединенныеФайлы(ЭтаФорма, Объект.Задача, "Объект.ТекстСообщения",
		Объект.ТекстСообщенияФормат);
	УстановитьТекстПоляИстория();

	ЗаполнитьПолучателейПоЗадаче();
	СформироватьПредставлениеКонтакта();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Объект.Наименование="Комментарий " + Объект.Автор + " от " + Объект.ДатаСоздания;

	РедакторКомментарияКлиент.ПередЗаписью(ЭтаФорма, "Объект.ТекстСообщения", Объект.ТекстСообщенияФормат);
	
	Если Не ЗначениеЗаполнено(СокрЛП(Объект.ТекстСообщения)) Тогда
		Отказ=Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ДобавленКомментарийКЗадаче", Объект.Задача, Объект.Ссылка);

	ПутьКДаннымБезЛишнего=РедакторКомментарияКлиентСервер.ПолучитьПутьКДаннымБезЛишнего("Объект.ТекстСообщения",
		Объект.ТекстСообщенияФормат);
	УправлениеЗадачамиКлиент.ОбновитьИсториюЗадачи(Объект.Задача, Элементы.ИсторияЗадачи, ЭтотОбъект,
		РедакторКомментарияКлиент.ДанныеПрисоединенныхФайлов(ЭтаФорма, ПутьКДаннымБезЛишнего,
		Объект.ТекстСообщенияФормат));
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	РедакторКомментария.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, "Объект.ТекстСообщения",
		Объект.ТекстСообщенияФормат);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
//	РедакторКомментария.ПриЗаписиНаСервере(ЭтаФорма, ТекущийОбъект.Задача, "Объект.ТекстСообщения",
//		Объект.ТекстСообщенияФормат, ТекущийОбъект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	РедакторКомментария.ПослеЗаписиНаСервере(ЭтаФорма, "Объект.ТекстСообщения", Объект.ТекстСообщенияФормат);
КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	РедакторКомментарияКлиент.ПриЗакрытии(ЭтаФорма, "Объект.ТекстСообщения", Объект.ТекстСообщенияФормат);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Не Открыта() Тогда
		Возврат;
	КонецЕсли;

//	Если ИмяСобытия = "ИзменилисьДопАдресаДляЭлектроннойПочты" И Параметр = УникальныйИдентификатор Тогда
//		УправлениеЗадачамиКлиентСервер.ОбновитьНадписьКоличестваДополнительныхПолучателейСообщений(Объект,
//			Элементы.ЭлектроннаяПочтаКонтактаОбращенияКопии);
//		Модифицированность=Истина;
//	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсторияЗадачиДокументСформирован(Элемент)
	ПутьКДаннымБезЛишнего=РедакторКомментарияКлиентСервер.ПолучитьПутьКДаннымБезЛишнего("Объект.ТекстСообщения",
		Объект.ТекстСообщенияФормат);
	УправлениеЗадачамиКлиент.ОбновитьИсториюЗадачи(Объект.Задача, Элементы.ИсторияЗадачи, ЭтотОбъект,
		РедакторКомментарияКлиент.ДанныеПрисоединенныхФайлов(ЭтаФорма, ПутьКДаннымБезЛишнего,
		Объект.ТекстСообщенияФормат));
КонецПроцедуры

&НаКлиенте
Процедура ИсторияЗадачиПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	УправлениеЗадачамиКлиент.ПриНажатииПоляИсторииЗадачи(ЭтотОбъект, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура ПредставлениеПолучателейНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	УправлениеЗадачамиКлиент.РедактироватьКопииПолучателейСобытияЗадачи(Объект.ДополнительныеПолучателиОповещения,
		Новый ОписаниеОповещения("ПредставлениеПолучателейНажатиеЗавершение", ЭтотОбъект));
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область ПодключаемыеКоманды

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
Процедура РВ_РедакторWysiwyg_Подключаемый_ПриДобавленииПрисоединенногоФайла(ИмяФайла, ИдентификаторФайла,
	ПутьКДаннымБезЛишнего) Экспорт
	РВ_РедакторWysiwyg_Подключаемый_ПриДобавленииПрисоединенногоФайлаНаСервере(ИмяФайла, ИдентификаторФайла,
		ПутьКДаннымБезЛишнего);
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

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПредставлениеПолучателейНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Объект.ДополнительныеПолучателиОповещения.Очистить();

	Для Каждого Стр Из Результат Цикл
		НС=Объект.ДополнительныеПолучателиОповещения.Добавить();
		ЗаполнитьЗначенияСвойств(НС, Стр);
	КонецЦикла;
	СформироватьПредставлениеКонтакта();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПолучателейПоЗадаче()
	Контакт = Объект.Задача.КонтактОбращения;
	Если ЗначениеЗаполнено(Контакт) Тогда

		Адрес=УправлениеЗадачами.АдресЭлектроннойПочтыОбъекта(Контакт);
		Если ЗначениеЗаполнено(Адрес) Тогда
			НовыйПолучатель=Объект.ДополнительныеПолучателиОповещения.Добавить();
			НовыйПолучатель.Адрес=Адрес;
			НовыйПолучатель.Представление=Строка(Контакт);
			НовыйПолучатель.Контакт=Контакт;
			НовыйПолучатель.ВариантОтправки="Кому:";
		КонецЕсли;
		Объект.ОтправитьСообщениеКонтакту=Истина;
	КонецЕсли;

	Для Каждого Стр Из Объект.Задача.ПолучателиКопий Цикл
		НовыйПолучатель=Объект.ДополнительныеПолучателиОповещения.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйПолучатель, Стр);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстПоляИстория()
	ИсторияЗадачи=УправлениеЗадачамиПовтИсп.СформироватьТекстHTMLДляПредставленияИсторииЗадачи();
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеКонтакта()
	ПредставлениеПолучателей="";
	Для Каждого Получатель Из Объект.ДополнительныеПолучателиОповещения Цикл
		АдресЭлектроннойПочты=УправлениеЗадачами.АдресЭлектроннойПочтыОбъекта(Получатель.Контакт);
		АдресЭлектроннойПочты=СокрЛП(АдресЭлектроннойПочты);

		ПредставлениеПолучателей=ПредставлениеПолучателей + ?(ЗначениеЗаполнено(ПредставлениеПолучателей), ";", "")
			+ ВзаимодействияКлиентСервер.ПолучитьПредставлениеАдресата("", АдресЭлектроннойПочты, Получатель.Контакт);
	КонецЦикла;

	Если Не ЗначениеЗаполнено(ПредставлениеПолучателей) Тогда
		ПредставлениеПолучателей="Задать получателей";
	КонецЕсли;
//	УправлениеЗадачамиКлиентСервер.ОбновитьНадписьКоличестваДополнительныхПолучателейСообщений(Объект,
//		Элементы.ЭлектроннаяПочтаКонтактаОбращенияКопии);
КонецПроцедуры
#КонецОбласти
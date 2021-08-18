#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	РедакторКомментария.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаСодержание, "Объект.Содержание",
		Объект.СодержаниеФормат);

	Если Объект.Ссылка.Пустая() Тогда

		Если Не ЗначениеЗаполнено(Объект.Исполнитель) Тогда
			Объект.Исполнитель = Пользователи.ТекущийПользователь();
		КонецЕсли;

		Если Не ЗначениеЗаполнено(Объект.ОценкаТрудозатратИсполнителя) Тогда
			Объект.ОценкаТрудозатратИсполнителя = 1;
		КонецЕсли;

		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) И Параметры.Свойство("ОчищатьТемуПриКопировании") Тогда

			Объект.Тема = "";
			Объект.Содержание = "";

		КонецЕсли;

	КонецЕсли;
	УстановитьАтрибутыСтопЛиста();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	РедакторКомментарияКлиент.ПередЗаписью(ЭтаФорма, "Объект.Содержание", Объект.СодержаниеФормат);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	РедакторКомментария.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, "Объект.Содержание", Объект.СодержаниеФормат);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
//	РедакторКомментария.ПриЗаписиНаСервере(ЭтаФорма, ТекущийОбъект.Ссылка, "Объект.Содержание", Объект.СодержаниеФормат, ТекущийОбъект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	РедакторКомментария.ПослеЗаписиНаСервере(ЭтаФорма, "Объект.Содержание", Объект.СодержаниеФормат);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	РедакторКомментарияКлиент.ПриЗакрытии(ЭтаФорма, "Объект.Содержание", Объект.СодержаниеФормат);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОценкаТрудозатратРегулирование(Элемент, Направление, СтандартнаяОбработка)
	УправлениеЗадачамиКлиент.ПолеЧасовРегулирование(ЭтотОбъект, "Объект.ОценкаТрудозатрат", Направление,
		СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОценкаТрудозатратИсполнителяРегулирование(Элемент, Направление, СтандартнаяОбработка)
	УправлениеЗадачамиКлиент.ПолеОценкаИсполнителяРегулирование(ЭтотОбъект, "Объект.ОценкаТрудозатратИсполнителя",
		Направление, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СпринтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Проект", Объект.Проект);
	ОткрытьФорму("Документ.Спринт.ФормаВыбора", ПараметрыФормы, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
	УстановитьАтрибутыСтопЛиста();
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьИПродолжить(Команда)

	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Если Не Записать(ПараметрыЗаписи) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыНовойЗадачи = Новый Структура;
	ПараметрыНовойЗадачи.Вставить("ЗначениеКопирования", Объект.Ссылка);
	ПараметрыНовойЗадачи.Вставить("ОчищатьТемуПриКопировании", Истина);
	ОткрытьФорму("Документ.Задача.Форма.ФормаДокументаНовойЗадачи", ПараметрыНовойЗадачи);

	Закрыть();

КонецПроцедуры

#КонецОбласти
#Область СлужебныеПроцедурыИФункции

#Область ПодключаемыеКоманды

#Область РВ_РедакторWysiwygHTML
//@skip-warning
&НаКлиенте
Процедура РВ_РедакторWysiwyg_Подключаемый_ДокументСформированПоляРедактированияКомментария(Элемент)
	РВ_РедакторWysiwygHTMLКлиент.ДокументСформированПоляРедактированияКомментария(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РВ_РедакторWysiwyg_Подключаемый_ДокументПриНажатииПоляРедактированияКомментария(Элемент, ДанныеСобытия,
	СтандартнаяОбработка)
	РВ_РедакторWysiwygHTMLКлиент.ДокументПриНажатииПоляРедактированияКомментария(ЭтаФорма, Элемент, ДанныеСобытия,
		СтандартнаяОбработка);
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

&НаКлиенте
Процедура Реквизит1ПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры
#КонецОбласти

#КонецОбласти

&НаСервере
Процедура УстановитьАтрибутыСтопЛиста()
	ДанныеПринадлежностиПартнераКСтопЛисту = СтопЛист.ДанныеПринадлежностиПартнераКСтопЛисту(Объект.Проект.Партнер);

	ПартнерПринадлежитКСтопЛисту = ДанныеПринадлежностиПартнераКСтопЛисту.Принадлежит;

	Если ПартнерПринадлежитКСтопЛисту Тогда
		ЦветФона = СтопЛист.ЦветФонаДляВыделенияСтопЛиста();
	Иначе
		ЦветФона = Новый Цвет;
	КонецЕсли;

	Элементы.ГруппаОсновная.ЦветФона = ЦветФона;

КонецПроцедуры

#КонецОбласти
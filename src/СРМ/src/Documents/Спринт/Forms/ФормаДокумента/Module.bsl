#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	РМ_MarkdownСервер.ВставитьПолеРедактированияТекстаНаФорму(ЭтаФорма,Элементы.ГруппаОписание, "Объект.Описание");
	РМ_MarkdownСервер.ВставитьПолеРедактированияТекстаНаФорму(ЭтаФорма,Элементы.ГруппаРезультат, "Объект.Результат");
	РМ_MarkdownСервер.ПрочитатьПрисоединенныеФайлы(ЭтаФорма, Объект.Ссылка,"Объект.Описание");
	РМ_MarkdownСервер.ПрочитатьПрисоединенныеФайлы(ЭтаФорма, Объект.Ссылка,"Объект.Результат");
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ЗадачиСпринта, "ТекущийСпринт", Объект.Ссылка, Истина);
	
	УстановитьУсловноеОформление();
	
	ОбновитьСтатистикуСпринта();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ЗадачиСпринта, "ТекущийСпринт", Объект.Ссылка, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененаЗадача" Тогда
		Элементы.ЗадачиСпринта.Обновить();
		ОбновитьСтатистикуСпринта();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	РМ_MarkdownСервер.ЗаписатьНовыеПрисоединенныеФайлы(ЭтаФорма, ТекущийОбъект.Ссылка,"Объект.Описание");	
	РМ_MarkdownСервер.ЗаписатьНовыеПрисоединенныеФайлы(ЭтаФорма, ТекущийОбъект.Ссылка,"Объект.Результат");	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	РМ_MarkdownСервер.УдалитьНовыеПрисоединенныеФайлыСФормыПослеЗаписи(ЭтаФорма,"Объект.Описание");	
	РМ_MarkdownСервер.УдалитьНовыеПрисоединенныеФайлыСФормыПослеЗаписи(ЭтаФорма,"Объект.Результат");	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Шаблоны = Новый Массив;
	Шаблоны.Добавить("[Версия]");
	Шаблоны.Добавить("[Проект]");
	Шаблоны.Добавить("[Проект] - [Версия]");
	Шаблоны.Добавить("[Проект] - [Участники]");
	Шаблоны.Добавить("[Проект] - [Версия] - [Участники]");
	
	МассивУчастников = Новый Массив;
	Для Каждого Стр Из Объект.Участники Цикл
		Если ЗначениеЗаполнено(Стр.Пользователь) И МассивУчастников.Найти(Стр.Пользователь) = Неопределено Тогда
			МассивУчастников.Добавить(Стр.Пользователь);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыПредставления = Новый Структура;
	ПараметрыПредставления.Вставить("Версия", Объект.Версия);
	ПараметрыПредставления.Вставить("Проект", Объект.Проект);
	ПараметрыПредставления.Вставить("Участники", СтрСоединить(МассивУчастников, "; "));
	
	ДанныеВыбора = Новый СписокЗначений;
	Для Каждого СтрокаШаблона Из Шаблоны Цикл
		ДанныеВыбора.Добавить(СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(СтрокаШаблона, ПараметрыПредставления));
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыЗадачиСпринта

&НаКлиенте
Процедура ЗадачиСпринтаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(,Элементы.ЗадачиСпринта.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура СобратьРелизЛог(Команда)
	СобратьРелизЛогНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультат;
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды


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

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СобратьРелизЛогНаСервере()
	
	ТекстРезультата = Новый ТекстовыйДокумент;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	""New"" КАК Категория,
	|	Задача.Ссылка КАК Ссылка,
	|	Задача.Номер КАК Номер,
	|	Задача.Тема КАК Тема,
	|	Задача.Содержание КАК Содержание
	|ИЗ
	|	Документ.Задача КАК Задача
	|ГДЕ
	|	Задача.Спринт = &Спринт
	|	И Задача.Статус В (&Выполненные, &Закрытые)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Категория,
	|	Номер
	|ИТОГИ ПО
	|	Категория";
	
	Запрос.УстановитьПараметр("Спринт", Объект.Ссылка);
	Запрос.УстановитьПараметр("Выполненные", УправлениеЗадачамиПовтИсп.СтатусыСписка(Справочники.СпискиСтатусовЗадач.Выполненные));
	Запрос.УстановитьПараметр("Закрытые", УправлениеЗадачамиПовтИсп.СтатусыСписка(Справочники.СпискиСтатусовЗадач.Закрытые));
	
	ВыборкаКатегория = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТекстРезультата.ДобавитьСтроку("# Спринт: " + Объект.Наименование);
	ТекстРезультата.ДобавитьСтроку("дата релиза: " + Формат(ТекущаяДатаСеанса(),"ДФ=dd.MM.yyyy"));
	
	Пока ВыборкаКатегория.Следующий() Цикл
		
		ТекстРезультата.ДобавитьСтроку("");
		ТекстРезультата.ДобавитьСтроку("### " + ВыборкаКатегория.Категория);
		ТекстРезультата.ДобавитьСтроку("");
		
		ВыборкаЗадача = ВыборкаКатегория.Выбрать();
		
		Пока ВыборкаЗадача.Следующий() Цикл
			
			ТекстРезультата.ДобавитьСтроку("* " + ВыборкаЗадача.Тема);
			Если ЗначениеЗаполнено(ВыборкаЗадача.Содержание) Тогда
				АбзацыСодержания = СтрРазделить(ВыборкаЗадача.Содержание, Символы.ПС, Ложь);
				Для Каждого Абзац Из АбзацыСодержания Цикл
					ТекстРезультата.ДобавитьСтроку("*" + Абзац + "*");
				КонецЦикла;
			КонецЕсли;
			ТекстРезультата.ДобавитьСтроку("");
			
		КонецЦикла;
		
	КонецЦикла;
	
	Объект.Результат = ТекстРезультата.ПолучитьТекст();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	УсловноеОформлениеСписка = ЗадачиСпринта.КомпоновщикНастроек.Настройки.УсловноеОформление;
	
	УсловноеОформлениеСписка.Элементы.Очистить();
	
	// Оформление для закрытых
	ЭлементУсловногоОформления = УсловноеОформлениеСписка.Элементы.Добавить();
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Статус");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ЭлементОтбораДанных.ПравоеЗначение = УправлениеЗадачамиПовтИсп.СтатусыНеВыполненныхЗадач();
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементШрифтаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Шрифт");
	ЭлементШрифтаОформления.Значение = ШрифтыСтиля.УдаленныйДополнительныйРеквизитШрифт;
	ЭлементШрифтаОформления.Использование = Истина;
	
	// Оформление для задач к выполнению
	ЭлементУсловногоОформления = УсловноеОформлениеСписка.Элементы.Добавить();
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Статус");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбораДанных.ПравоеЗначение = УправлениеЗадачамиПовтИсп.СтатусыСписка(Справочники.СпискиСтатусовЗадач.КВыполнению);
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементШрифтаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Шрифт");
	ЭлементШрифтаОформления.Значение = ШрифтыСтиля.НеПринятыеКИсполнениюЗадачи;
	ЭлементШрифтаОформления.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатистикуСпринта()
	
	Статистика = СтатистикаПоЗадачам();
	
	СтрокаВсегоЗадач = СтрШаблон("Всего задач: %1", Статистика.ВсегоЗадач);
	СтрокаКоличествоВыполненных = СтрШаблон("- из них выполнено: %1 (%2%%)", Статистика.КоличествоВыполненных, Статистика.ПроцентВыполненныхПоКоличеству);
	СтрокаОценкаТрудозатратВсего = СтрШаблон("Всего оценка трудозатрат: %1 ч", Статистика.ОценкаТрудозатратВсего);
	СтрокаОценкаТрудозатратВыполненных = СтрШаблон("- из них выполнено: %1 ч (%2%%)", Статистика.ОценкаТрудозатратВыполненных, Статистика.ПроцентВыполненныхПоОценке);
	СтрокаВсегоТрудозатрат = СтрШаблон("Всего трудозатрат по спринту: %1 ч", Статистика.ФактическиеТрудозатратыВсегоПоСпринту);
	СтрокаТрудозатратПоВыполненнымЗадачам = СтрШаблон("- из них по выполненным задачам: %1 ч", Статистика.ФактическиеТрудозатратыВыполненныхЗадач);
	СтрокаЭффективность = СтрШаблон("Эффективность по выполненным задачам: %1%%", Статистика.ЭффективностьПоВыполеннымЗадачам);
	СтрокаЭффективностьПояснение = "[Эффективность] = 100% * [Оценка трудозатрат] / [Фактические трудозатраты]";
	
	Если НЕ ЗначениеЗаполнено(Статистика.ЭффективностьПоВыполеннымЗадачам) Тогда
		ЦветЭффективности = Новый Цвет;
	ИначеЕсли Статистика.ЭффективностьПоВыполеннымЗадачам < 80 Тогда
		ЦветЭффективности = WebЦвета.Красный;
	ИначеЕсли Статистика.ЭффективностьПоВыполеннымЗадачам < 90 Тогда
		ЦветЭффективности = WebЦвета.Томатный;
	ИначеЕсли Статистика.ЭффективностьПоВыполеннымЗадачам < 100 Тогда
		ЦветЭффективности = WebЦвета.ТусклоОливковый;
	Иначе
		ЦветЭффективности = WebЦвета.Зеленый;	
	КонецЕсли;
	
	ЧастиСтроки = Новый Массив;
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока("Статистика:",ШрифтыСтиля.ВажнаяНадписьШрифт,ЦветаСтиля.ГиперссылкаЦвет));
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(СтрокаВсегоЗадач,ШрифтыСтиля.ОбычныйШрифтТекста,WebЦвета.Кирпичный));
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(СтрокаКоличествоВыполненных,ШрифтыСтиля.ОбычныйШрифтТекста,WebЦвета.Кирпичный));
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(СтрокаОценкаТрудозатратВсего,ШрифтыСтиля.ОбычныйШрифтТекста,WebЦвета.ЦветМорскойВолныНейтральный));
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(СтрокаОценкаТрудозатратВыполненных,ШрифтыСтиля.ОбычныйШрифтТекста,WebЦвета.ЦветМорскойВолныНейтральный));
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(СтрокаВсегоТрудозатрат,ШрифтыСтиля.ОбычныйШрифтТекста,WebЦвета.КоролевскиГолубой));
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(СтрокаТрудозатратПоВыполненнымЗадачам,ШрифтыСтиля.ОбычныйШрифтТекста,WebЦвета.КоролевскиГолубой));	
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(СтрокаЭффективность,ШрифтыСтиля.ВажнаяНадписьШрифт,ЦветЭффективности));
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(СтрокаЭффективностьПояснение,ШрифтыСтиля.МелкийШрифтТекста,ЦветЭффективности));
	
	Элементы.НадписьСтатистикаСпринта.Заголовок = Новый ФорматированнаяСтрока(ЧастиСтроки);
	
КонецПроцедуры

&НаСервере
Функция СтатистикаПоЗадачам()
	
	Статистика = Новый Структура(
		"ВсегоЗадач,КоличествоВыполненных,ОценкаТрудозатратВсего,ОценкаТрудозатратВыполненных,
		|ФактическиеТрудозатратыВсегоПоСпринту,ФактическиеТрудозатратыВсегоПоЗадачам,ФактическиеТрудозатратыВыполненныхЗадач", 
		0, 0, 0, 0, 0, 0, 0);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ВложенныйЗапрос.ВсегоЗадач) КАК ВсегоЗадач,
		|	СУММА(ВложенныйЗапрос.КоличествоВыполненных) КАК КоличествоВыполненных,
		|	СУММА(ВложенныйЗапрос.ОценкаТрудозатратВсего) КАК ОценкаТрудозатратВсего,
		|	СУММА(ВложенныйЗапрос.ОценкаТрудозатратВыполненных) КАК ОценкаТрудозатратВыполненных,
		|	СУММА(ВложенныйЗапрос.ФактическиеТрудозатратыВсегоПоСпринту) КАК ФактическиеТрудозатратыВсегоПоСпринту,
		|	СУММА(ВложенныйЗапрос.ФактическиеТрудозатратыВсегоПоЗадачам) КАК ФактическиеТрудозатратыВсегоПоЗадачам,
		|	СУММА(ВложенныйЗапрос.ФактическиеТрудозатратыВыполненныхЗадач) КАК ФактическиеТрудозатратыВыполненныхЗадач
		|ИЗ
		|	(ВЫБРАТЬ
		|		1 КАК ВсегоЗадач,
		|		ВЫБОР
		|			КОГДА Задача.Статус В (&НеВыполненные)
		|				ТОГДА 0
		|			ИНАЧЕ 1
		|		КОНЕЦ КАК КоличествоВыполненных,
		|		Задача.ОценкаТрудозатратИсполнителя КАК ОценкаТрудозатратВсего,
		|		ВЫБОР
		|			КОГДА Задача.Статус В (&НеВыполненные)
		|				ТОГДА 0
		|			ИНАЧЕ Задача.ОценкаТрудозатратИсполнителя
		|		КОНЕЦ КАК ОценкаТрудозатратВыполненных,
		|		0 КАК ФактическиеТрудозатратыВсегоПоСпринту,
		|		0 КАК ФактическиеТрудозатратыВсегоПоЗадачам,
		|		0 КАК ФактическиеТрудозатратыВыполненныхЗадач
		|	ИЗ
		|		Документ.Задача КАК Задача
		|	ГДЕ
		|		Задача.Спринт = &Спринт
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		0,
		|		0,
		|		0,
		|		0,
		|		ТрудозатратыОбороты.ФактОборот,
		|		ВЫБОР
		|			КОГДА ТрудозатратыОбороты.Предмет.Спринт = &Спринт
		|				ТОГДА ТрудозатратыОбороты.ФактОборот
		|			ИНАЧЕ 0
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА ТрудозатратыОбороты.Предмет.Статус В (&НеВыполненные)
		|				ТОГДА 0
		|			ИНАЧЕ ТрудозатратыОбороты.ФактОборот
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.Трудозатраты.Обороты(
		|				,
		|				,
		|				,
		|				Предмет = &Спринт
		|					ИЛИ Предмет.Спринт = &Спринт) КАК ТрудозатратыОбороты) КАК ВложенныйЗапрос";
		Запрос.УстановитьПараметр("Спринт", Объект.Ссылка);
		Запрос.УстановитьПараметр("НеВыполненные", УправлениеЗадачамиПовтИсп.СтатусыНеВыполненныхЗадач());
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(Статистика, Выборка);	
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Статистика.ВсегоЗадач) Тогда
		Статистика.Вставить("ПроцентВыполненныхПоКоличеству", Окр(100 * Статистика.КоличествоВыполненных/Статистика.ВсегоЗадач, 0));
	Иначе
		Статистика.Вставить("ПроцентВыполненныхПоКоличеству", 100);	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Статистика.ОценкаТрудозатратВсего) Тогда
		Статистика.Вставить("ПроцентВыполненныхПоОценке", Окр(100 * Статистика.ОценкаТрудозатратВыполненных/Статистика.ОценкаТрудозатратВсего, 0));
	Иначе
		Статистика.Вставить("ПроцентВыполненныхПоОценке", 100);	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Статистика.ФактическиеТрудозатратыВыполненныхЗадач) Тогда
		Статистика.Вставить("ЭффективностьПоВыполеннымЗадачам", Окр(100 * Статистика.ОценкаТрудозатратВыполненных/Статистика.ФактическиеТрудозатратыВыполненныхЗадач, 0));
	Иначе
		Статистика.Вставить("ЭффективностьПоВыполеннымЗадачам", 0);	
	КонецЕсли;
	
	Возврат Статистика;
	
КонецФункции

#КонецОбласти

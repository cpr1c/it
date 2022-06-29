#Область ПрограммныйИнтерфейс

Функция ТекущийОтчетПоРаботамПартнера(Партнер, ДатаПериодаРегистрации) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ОтчетПоРаботамПартнеру.Ссылка
	|ИЗ
	|	Документ.ОтчетПоРаботамПартнеру КАК ОтчетПоРаботамПартнеру
	|ГДЕ
	|	ОтчетПоРаботамПартнеру.Партнер = &Партнер
	|	И ОтчетПоРаботамПартнеру.Статус = &Статус
	|	И ОтчетПоРаботамПартнеру.Проведен
	|	И ОтчетПоРаботамПартнеру.ПериодРегистрации = &ПериодРегистрации";
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыОтчетовПоРаботамПартнеру.Формируется);
	Запрос.УстановитьПараметр("ПериодРегистрации", НачалоМесяца(ДатаПериодаРегистрации));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Документы.ОтчетПоРаботамПартнеру.ПустаяСсылка();
	КонецЕсли;
КонецФункции

#Область СтандартныеПодсистемы
// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Отчет по работам
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ОтчетПоРаботамПартнеру";
	КомандаПечати.Идентификатор = "ОтчетПоРаботе";
	КомандаПечати.Представление = НСтр("ru = 'Отчет по работе'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина; 
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов – Массив – ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати – Структура – дополнительные настройки печати;
//  КоллекцияПечатныхФорм – ТаблицаЗначений – сформированные табличные документы (выходной параметр)
//  ОбъектыПечати – СписокЗначений – значение – ссылка на объект;
//                                            представление – имя области, в которой был выведен объект (выходной параметр);
//  ПараметрыВывода – Структура – дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
   ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ОтчетПоРаботе");
    Если ПечатнаяФорма <> Неопределено Тогда
        ПечатнаяФорма.ТабличныйДокумент = ПечатьОтчетаПоРаботе(МассивОбъектов, ОбъектыПечати);
        ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Отчет по работе'");
		//ПечатнаяФорма.ПолныйПутьКМакету = "Документ._ДемоСчетНаОплатуПокупателю.ПФ_MXL_СчетЗаказ";
	КонецЕсли;
КонецПроцедуры

Функция ПечатьОтчетаПоРаботе(МассивОбъектов, ОбъектыПечати)
    // Создаем табличный документ и устанавливаем имя параметров печати.
    ТабличныйДокумент = Новый ТабличныйДокумент;
    ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ОтчетПоРаботе";
	
	Макет=Документы.ОтчетПоРаботамПартнеру.ПолучитьМакет("ОтчетПоРаботе");
	
	
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ФормированиеЗаказа.Ссылка КАК Ссылка,
	|	ФормированиеЗаказа.ВерсияДанных КАК ВерсияДанных,
	|	ФормированиеЗаказа.ПометкаУдаления КАК ПометкаУдаления,
	|	ФормированиеЗаказа.Номер КАК Номер,
	|	ФормированиеЗаказа.Дата КАК Дата,
	|	ФормированиеЗаказа.Проведен КАК Проведен,
	|	ФормированиеЗаказа.Партнер КАК Партнер,
	|	ФормированиеЗаказа.ПериодРегистрации КАК ПериодРегистрации,
	|	ФормированиеЗаказа.Статус КАК Статус,
	|	ФормированиеЗаказа.Ответственный КАК Ответственный,
	|	ФормированиеЗаказа.Комментарий КАК Комментарий,
	|	ФормированиеЗаказа.Задачи.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Задача КАК Задача,
	|		Исполнитель КАК Исполнитель,
	|		КоличествоЧасов КАК КоличествоЧасов,
	|		ВидОплаты КАК ВидОплаты
	|	) КАК Задачи
	|ИЗ
	|	Документ.ОтчетПоРаботамПартнеру КАК ФормированиеЗаказа
	|ГДЕ
	|	ФормированиеЗаказа.Ссылка В(&МассивОбъектов)";
    
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Шапка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.Следующий() Цикл
	    Если Не ПервыйДокумент Тогда
	        // Все документы нужно выводить на разных страницах.
	        ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	    КонецЕсли;
	    ПервыйДокумент = Ложь;
	    // Запомним номер строки, с которой начали выводить текущий документ.
	    НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	    
		ОбластьЗаголовок=Макет.ПолучитьОбласть("Заголовок");
		ОбластьЗаголовок.Параметры.ТекстЗаголовка=СтрШаблон(НСтр("ru = '%1 № %2 от %3'"),"Отчет по работам", Шапка.Номер, Формат(Шапка.Дата, "ДЛФ=DD"));
		ОбластьЗаголовок.Параметры.МесяцРабот=Шапка.ПериодРегистрации;
		ОбластьЗаголовок.Параметры.Заказчик=Шапка.Партнер;
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		ТаблицаЗадач=Шапка.Задачи.Выгрузить();
		МассивВидовОплат=Новый Массив;
		Для Каждого Стр Из ТаблицаЗадач Цикл
			Если МассивВидовОплат.Найти(Стр.ВидОплаты)=Неопределено Тогда
				МассивВидовОплат.Добавить(Стр.ВидОплаты);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ВидОплаты ИЗ МассивВидовОплат Цикл
			ОбластьЗаголовок=Макет.ПолучитьОбласть("ЗаголовокТаблицы");
			ОбластьЗаголовок.Параметры.ЗаголовокТаблицы="Вид оплаты задачи: "+ВидОплаты;
			ТабличныйДокумент.Вывести(ОбластьЗаголовок);
			ОбластьЗаголовок=Макет.ПолучитьОбласть("ШапкаТаблицы");
			ТабличныйДокумент.Вывести(ОбластьЗаголовок);
			
			ИтогоЧасов=0;
			
			СтруктураОтбора=Новый Структура;
			СтруктураОтбора.Вставить("ВидОплаты", ВидОплаты);
			СтрокиЗадачПоВидуОплат=ТаблицаЗадач.НайтиСтроки(СтруктураОтбора);
			
			Для Каждого СтрокаТЗ ИЗ СтрокиЗадачПоВидуОплат Цикл
				ОбластьМакета=Макет.ПолучитьОбласть("Строка");
				Если ТипЗнч(СтрокаТЗ.Задача)=Тип("СправочникСсылка.RA_RedmineЗадачи") ТОгда
					ОбластьМакета.Параметры.НомерЗадачи=СтрокаТЗ.Задача.Код;
					ОбластьМакета.Параметры.Тема=СтрокаТЗ.Задача.Наименование;
				Иначе
					ОбластьМакета.Параметры.НомерЗадачи=СтрокаТЗ.Задача.Номер;
					ОбластьМакета.Параметры.Тема=СтрокаТЗ.Задача.Тема;
				КонецЕсли;
				ОбластьМакета.Параметры.КоличествоЧасов=СтрокаТЗ.КоличествоЧасов;
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
				ИтогоЧасов=ИтогоЧасов+СтрокаТЗ.КоличествоЧасов;
			КонецЦикла;
			
			ОбластьИтого=Макет.ПолучитьОбласть("Итого");
			ОбластьИтого.Параметры.Всего=ИтогоЧасов;
			ТабличныйДокумент.Вывести(ОбластьИтого);
		КонецЦикла;
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати комплектов документов.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
		НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	Возврат ТабличныйДокумент;
КонецФункции


// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Статус");
	Результат.Добавить("Задачи.*");
	Результат.Добавить("ПериодРегистрации");
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти

#КонецОбласти
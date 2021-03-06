Функция ПечатьНачисленийПоДоговорам(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_НачисленияПлатежей";
	
	ИмяМакета = "Начисления";
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачислениеПлатежей.Ссылка КАК Ссылка,
	|	НачислениеПлатежей.ПериодРегистрации КАК ПериодРегистрации,
	|	НачислениеПлатежей.Организация КАК Организация,
	|	НачислениеПлатежей.Периодичность КАК Периодичность,
	|	НачислениеПлатежей.Вид КАК Вид,
	|	НачислениеПлатежей.ВидНачисления КАК ВидНачисления,
	|	НачислениеПлатежей.НачисленияАренды.(
	|		Периодичность КАК Периодичность,
	|		Контрагент КАК Контрагент,
	|		Договор КАК Договор,
	|		СтавкаНДС КАК СтавкаНДС,
	|		Сумма КАК Сумма,
	|		Всего КАК Всего,
	|		КБК КАК КБК
	|	),
	|	НачислениеПлатежей.НачисленияРеализации.(
	|		Периодичность КАК Периодичность,
	|		Контрагент КАК Контрагент,
	|		Договор КАК Договор,
	|		СтавкаНДС КАК СтавкаНДС,
	|		Сумма КАК Сумма,
	|		Всего КАК Всего,
	|		КБК КАК КБК
	|	),
	|	НачислениеПлатежей.НачисленияПеней.(
	|		Периодичность КАК Периодичность,
	|		Контрагент КАК Контрагент,
	|		Договор КАК Договор,
	|		СтавкаНДС КАК СтавкаНДС,
	|		Сумма КАК Сумма,
	|		Всего КАК Всего,
	|		КБК КАК КБК
	|	),
	|	НачислениеПлатежей.Номер,
	|	НачислениеПлатежей.Дата
	|ИЗ
	|	Документ.НачислениеПлатежей КАК НачислениеПлатежей
	|ГДЕ
	|	НачислениеПлатежей.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Начисления_Начисления";
		
		Макет = УправлениеПечатью.ПолучитьМакет("Документ.НачислениеПлатежей.Начисления");
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Организация = Шапка.Организация;
		ОбластьМакета.Параметры.НомерДок	= Шапка.Номер;
		ОбластьМакета.Параметры.ДатаДок		= Формат(Шапка.Дата, "ДФ='dd.MM.yyyy ""г.""'");
		ОбластьМакета.Параметры.ПериодНачисления		= Формат(Шапка.ПериодРегистрации,"ДФ='MMMM yyyy ""г.""'");
		ОбластьМакета.Параметры.ВидДоговора	= Шапка.Вид;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		ИтогоСумма = 0;

		ВЫборкаНачисленияАренды=Шапка.НачисленияАренды.Выбрать();
		
		НомерСтроки=1;
		
		Пока ВЫборкаНачисленияАренды.Следующий() Цикл
			
			ОбластьМакета.Параметры.Ном 		= НомерСтроки;
			ОбластьМакета.Параметры.Договор 	= ВЫборкаНачисленияАренды.Договор;
			ОбластьМакета.Параметры.Контрагент 	= ВЫборкаНачисленияАренды.Контрагент;
			ОбластьМакета.Параметры.КБК		 	= ВЫборкаНачисленияАренды.КБК;
			ОбластьМакета.Параметры.Сумма	 	= ВЫборкаНачисленияАренды.Всего;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ИтогоСумма = ИтогоСумма + ВЫборкаНачисленияАренды.Всего;
			
			НомерСтроки=НомерСтроки+1;
		КонецЦикла;
		
		ВЫборкаНачисленияРеализации=Шапка.НачисленияРеализации.Выбрать();
		Пока ВЫборкаНачисленияРеализации.Следующий() Цикл
			
			ОбластьМакета.Параметры.Ном 		= НомерСтроки;
			ОбластьМакета.Параметры.Договор 	= ВЫборкаНачисленияРеализации.Договор;
			ОбластьМакета.Параметры.Контрагент 	= ВЫборкаНачисленияРеализации.Контрагент;
			ОбластьМакета.Параметры.КБК		 	= ВЫборкаНачисленияРеализации.КБК;
			ОбластьМакета.Параметры.Сумма	 	= ВЫборкаНачисленияРеализации.Всего;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ИтогоСумма = ИтогоСумма + ВЫборкаНачисленияРеализации.Всего;
			
			НомерСтроки=НомерСтроки+1;
		КонецЦикла;
		
		ВЫборкаНачисленияПеней=Шапка.НачисленияПеней.Выбрать();
		Пока ВЫборкаНачисленияПеней.Следующий() Цикл
			
			ОбластьМакета.Параметры.Ном 		= НомерСтроки;
			ОбластьМакета.Параметры.Договор 	= ВЫборкаНачисленияПеней.Договор;
			ОбластьМакета.Параметры.Контрагент 	= ВЫборкаНачисленияПеней.Контрагент;
			ОбластьМакета.Параметры.КБК		 	= ВЫборкаНачисленияПеней.КБК;
			ОбластьМакета.Параметры.Сумма	 	= ВЫборкаНачисленияПеней.Всего;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ИтогоСумма = ИтогоСумма + ВЫборкаНачисленияПеней.Всего;
			
			НомерСтроки=НомерСтроки+1;
		КонецЦикла;

		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		
		ОбластьМакета.Параметры.ИтогоСумма = Формат(ИтогоСумма,"ЧДЦ=2; ЧРД=-");
	
		ТабличныйДокумент.Вывести(ОбластьМакета);

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст ошибки)
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя области в которой был выведен объект)
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Начисления") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм,
						"Начисления", "Начисления",
						ПечатьНачисленийПоДоговорам(МассивОбъектов, ОбъектыПечати), ,
						"Документ.НачислениеПлатежей.Начисления");
	КонецЕсли;
	
КонецПроцедуры


#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Респондент");
	Результат.Добавить("ДатаРедактирования");
	Результат.Добавить("Комментарий");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления.

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Анкета.Ссылка
		|ИЗ
		|	Документ.Анкета КАК Анкета
		|ГДЕ
		|	Анкета.РежимАнкетирования = &ПустаяСсылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Анкета.Дата УБЫВ";
	Запрос.Параметры.Вставить("ПустаяСсылка", Перечисления.РежимыАнкетирования.ПустаяСсылка());
	
	Результат = Запрос.Выполнить().Выгрузить();
	МассивСсылок = Результат.ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// Заполнить значение нового реквизита РежимАнкетирования у документа Анкета.
// 
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Документ.Анкета");
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			ЗаполнитьРеквизитРежимАнкетирования(Выборка);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			// Если не удалось обработать анкету, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать анкету: %1 по причине:
					|%2'"), 
					Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Документы.Анкета, Выборка.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Документ.Анкета");
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре ЗаполнитьРеквизитРежимАнкетирования не удалось обработать некоторые анкеты (пропущены): %1'"), 
				ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Документы.Анкета,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Процедура ЗаполнитьРеквизитРежимАнкетирования обработала очередную порцию анкет: %1'"),
					ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет значение нового реквизита РежимАнкетирования у переданного документа.
//
Процедура ЗаполнитьРеквизитРежимАнкетирования(Выборка)
	
	НачатьТранзакцию();
	Попытка
	
		// Блокируем объект от изменения другими сеансами.
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Документ.Анкета");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
		Блокировка.Заблокировать();
		
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		// Если объект ранее был удален или обработан другими сеансами, пропускаем его.
		Если ДокументОбъект = Неопределено Тогда
			ОтменитьТранзакцию();
			Возврат;
		КонецЕсли;
		Если ДокументОбъект.РежимАнкетирования <> Перечисления.РежимыАнкетирования.ПустаяСсылка() Тогда
			ОтменитьТранзакцию();
			Возврат;
		КонецЕсли;
		
		// Обработка объекта.
		ДокументОбъект.РежимАнкетирования = Перечисления.РежимыАнкетирования.Анкета;
		
		// Запись обработанного объекта.
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
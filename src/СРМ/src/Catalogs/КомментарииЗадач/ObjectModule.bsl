
Процедура ПередЗаписью(Отказ)
	Наименование = ТекстСообщения;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Задача") Тогда
		// Заполнение шапки
		Задача = ДанныеЗаполнения.Ссылка;
		Контакт = Задача.КонтактОбращения;
		
		Для Каждого Стр ИЗ Задача.ПолучателиКопий Цикл
			НовыйПолучатель=ПолучателиКопий.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйПолучатель,Стр);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Задача") Тогда
			Для Каждого Стр ИЗ ДанныеЗаполнения.Задача.ПолучателиКопий Цикл
				НовыйПолучатель = ПолучателиКопий.Добавить();
				ЗаполнитьЗначенияСвойств(НовыйПолучатель,Стр);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ТекстСообщенияФормат) Тогда
		ТекстСообщенияФормат=УправлениеЗадачамиПовтИсп.ФорматТекстаКомментарияПоУмолчанию();
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	
КонецПроцедуры

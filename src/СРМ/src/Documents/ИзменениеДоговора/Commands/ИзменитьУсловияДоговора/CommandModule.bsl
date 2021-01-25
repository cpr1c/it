
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗаключениеДоговора = Аренда.НайтиЗаключениеДоговора(ПараметрКоманды);
	
	Если Не ЗначениеЗаполнено(ЗаключениеДоговора) Тогда
		Сообщить("Договор еще не заключен. Изменение условий невозможно.");
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Договор", ПараметрКоманды);
	
	ОткрытьФорму("Документ.ИзменениеДоговора.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения));
	
КонецПроцедуры

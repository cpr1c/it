
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ЗначенияЗаполнения=Новый Структура;
	ЗначенияЗаполнения.Вставить("Основание",ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	ОткрытьФорму("Документ.Трудозатраты.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

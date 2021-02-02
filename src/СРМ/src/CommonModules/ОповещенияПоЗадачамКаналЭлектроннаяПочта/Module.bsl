Процедура ВыполнитьОтправкуСообщения(Сообщение, УчетнаяЗаписьОповещений, ОписаниеОшибки) Экспорт

	УчетнаяЗаписьЭлектроннойПочты=УчетнаяЗаписьОповещений.Настройка;
	Если Сообщение.Получатель.Количество() = 0 Тогда
		ОписаниеОшибки  = НСтр(
			"ru = 'Сообщение не может быть отправлено сразу, т.к необходимо ввести адрес электронной почты.'");
		Возврат;
	КонецЕсли;

	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Тема", Сообщение.Тема);
	ПараметрыПисьма.Вставить("Тело", Сообщение.Текст);
	ПараметрыПисьма.Вставить("Вложения", Новый Соответствие);
	ПараметрыПисьма.Вставить("Кодировка", "utf-8");

	Для Каждого Вложение Из Сообщение.Вложения Цикл
		НовоеВложение = Новый Структура("ДвоичныеДанные, Идентификатор");
		НовоеВложение.ДвоичныеДанные = ПолучитьИзВременногоХранилища(Вложение.АдресВоВременномХранилище);
		НовоеВложение.Идентификатор = Вложение.Идентификатор;
		ПараметрыПисьма.Вложения.Вставить(Вложение.Представление, НовоеВложение);
	КонецЦикла;

	МодульРаботаСПочтовымиСообщениямиСлужебный = ОбщегоНазначения.ОбщийМодуль(
			"РаботаСПочтовымиСообщениямиСлужебный");
	Если Сообщение.ДополнительныеПараметры.ФорматПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
		ТипТекста = МодульРаботаСПочтовымиСообщениямиСлужебный.ТипТекстовЭлектронныхПисем("HTMLСКартинками");
	Иначе
		ТипТекста = МодульРаботаСПочтовымиСообщениямиСлужебный.ТипТекстовЭлектронныхПисем("ПростойТекст");
	КонецЕсли;

	ПараметрыПисьма.Вставить("ТипТекста", ТипТекста);
	Кому = СформироватьСписокПолучателейСообщения(Сообщение.Получатель);

	ПараметрыПисьма.Вставить("Кому", Кому);

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
		Если МодульРаботаСПочтовымиСообщениями.ДоступнаОтправкаПисем() Тогда

			МодульРаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗаписьЭлектроннойПочты, ПараметрыПисьма);

		Иначе

			ОписаниеОшибки  = НСтр("ru = 'Сообщение не может быть отправлено сразу.'");
			Возврат;

		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция АдресПолучателя(Получатель) Экспорт
	КИ=УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Получатель, , , Ложь);

	Отбор=Новый Структура;
	Отбор.Вставить("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);

	НайденныеСтроки=КИ.НайтиСтроки(Отбор);

	Адрес="";
	Для Каждого Стр Из НайденныеСтроки Цикл
		Если Не ЗначениеЗаполнено(Стр.Представление) Тогда
			Продолжить;
		КонецЕсли;

		Адрес=Стр.Представление;
		Прервать;
	КонецЦикла;

	Возврат Адрес;
КонецФункции

Функция ТекстИзмененийДляСообщения(Изменения) Экспорт
	ТекстИзменений="";

	Если Изменения.Количество() > 0 Тогда
		ТекстИзменений="<hr>" + Символы.ПС + "<ul>" + Символы.ПС;
		Для Каждого ТекИзменение Из Изменения Цикл
			ТекстИзменений=ТекстИзменений + "<li>Параметр <strong>" + ТекИзменение.Значение.Синоним + "</strong> изменился с <i>"
				+ ТекИзменение.Значение.ПредыдущееЗначение + "</i> на <i>" + ТекИзменение.Значение.Значение
				+ "</i></li>" + Символы.ПС;
		КонецЦикла;

		ТекстИзменений=ТекстИзменений + "</ul>";

	КонецЕсли;
	Возврат ТекстИзменений;
КонецФункции

Функция ТекстКомментарияПреобразованный(Сообщение,КомментарийИзБазы) Экспорт
	Возврат КомментарийИзБазы;
КонецФункции

Функция СформироватьСписокПолучателейСообщения(СписокПолучателей)

	СпискаПолучателейСКонтактом = (ТипЗнч(СписокПолучателей) = Тип("Массив"));

	Кому = Новый Массив;
	Для Каждого Получатель Из СписокПолучателей Цикл
		ПолучательСообщения = Новый Структура;
		ПолучательСообщения.Вставить("Представление", Получатель.Представление);

		Если СпискаПолучателейСКонтактом Тогда
			ПолучательСообщения.Вставить("Адрес", Получатель.Адрес);
			ПолучательСообщения.Вставить("Контакт", Получатель.ИсточникКонтактнойИнформации);
		Иначе
			ПолучательСообщения.Вставить("Адрес", Получатель.Значение);
		КонецЕсли;

		Кому.Добавить(ПолучательСообщения);
	КонецЦикла;

	Возврат Кому;

КонецФункции
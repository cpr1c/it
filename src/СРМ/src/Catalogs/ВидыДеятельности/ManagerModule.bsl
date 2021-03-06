
// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


Функция ПолучитьВидДеятельностиПоУмолчанию() Экспорт
	
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыДеятельности.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыДеятельности КАК ВидыДеятельности
	|ГДЕ
	|	НЕ ВидыДеятельности.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыДеятельности.РеквизитДопУпорядочивания";
	Выборка=Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.ВидыДеятельности.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции 
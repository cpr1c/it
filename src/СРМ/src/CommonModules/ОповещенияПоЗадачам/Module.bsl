#Область ПрограммныйИнтерфейс

// Определяет состав назначений и общие реквизиты в шаблонах сообщений 
//
// Параметры:
//  Настройки - Структура - Структура с ключами:
//    * ПредметыШаблонов - ТаблицаЗначений - Содержит варианты предметов для шаблонов. Колонки:
//         ** Имя           - Строка - Уникальное имя назначения.
//         ** Представление - Строка - Представление варианта.
//         ** Макет         - Строка - Имя макета СКД, если состав реквизитов определяется посредством СКД.
//         ** ЗначенияПараметровСКД - Структура - Значения параметров СКД для текущего предмета шаблона сообщения.
//    * ОбщиеРеквизиты - ТаблицаЗначений - Содержит описание общих реквизитов доступных во всех шаблонах. Колонки:
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип общего реквизита. По умолчанию строка.
//    * ИспользоватьПроизвольныеПараметры  - Булево - указывает, можно ли использовать произвольные пользовательские
//                                                    параметры в шаблонах сообщений.
//    * ЗначенияПараметровСКД - Структура - Общие значения параметров СКД, для всех макетов, где состав реквизитов
//                                          определяется средствами СКД.
//
Процедура ПриОпределенииНастроекШаблоновСообщений(Настройки) Экспорт
	
	Предмет = Настройки.ПредметыШаблонов.Добавить();
	Предмет.Имя = "ОповещениеОбИзмененииЗадачиДляКонтакта";
	Предмет.Представление = НСтр("ru = 'Оповещение об изменении задачи для контакта'");
	
	Настройки.ИспользоватьПроизвольныеПараметры=Истина;
	Настройки.РасширенныйСписокПолучателей=Истина;
	Настройки.ФорматПисьма="HTML";
	
КонецПроцедуры

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Подсказка      - Строка - Расширенная информация о реквизите.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения
//         ** Имя            - Строка - Уникальное имя вложения.
//         ** Представление  - Строка - Представление варианта.
//         ** Подсказка      - Строка - Расширенная информация о вложении.
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl"
//                                      и др.
//  НазначениеШаблона       - Строка  - Имя назначения шаблон сообщения.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщения.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, НазначениеШаблона, ДополнительныеПараметры) Экспорт
	Если НазначениеШаблона="ОповещениеОбИзмененииЗадачиДляКонтакта"  Тогда
		
		НовыйРеквизит = Реквизиты.Добавить();
		НовыйРеквизит.Имя = "Задача";
		НовыйРеквизит.Представление = НСтр("ru = 'Задача'");
		НовыйРеквизит.Тип = Новый ОписаниеТипов("ДокументСсылка.Задача");
		
		//подчиненные реквизиты
		Для Каждого Реквизит ИЗ Метаданные.Документы.Задача.Реквизиты Цикл
			НовыйР = НовыйРеквизит.Строки.Добавить();
			НовыйР.Имя = НазначениеШаблона+".Задача."+Реквизит.Имя;
			НовыйР.Представление = Реквизит.Синоним;
			НовыйР.Тип = Реквизит.Тип;
		КонецЦикла;
		
		НовыйР = НовыйРеквизит.Строки.Добавить();
		НовыйР.Имя = НазначениеШаблона+".Задача."+Метаданные.Документы.Задача.СтандартныеРеквизиты.Номер.Имя;
		НовыйР.Представление = Метаданные.Документы.Задача.СтандартныеРеквизиты.Номер.Имя;
		НовыйР.Тип = Реквизит.Тип;
		
		НовыйР = НовыйРеквизит.Строки.Добавить();
		НовыйР.Имя = НазначениеШаблона+".Задача."+Метаданные.Документы.Задача.СтандартныеРеквизиты.Дата.Имя;
		НовыйР.Представление = Метаданные.Документы.Задача.СтандартныеРеквизиты.Дата.Имя;
		НовыйР.Тип = Реквизит.Тип;
		
		
		
		НовыйРеквизит = Реквизиты.Добавить();
		НовыйРеквизит.Имя = "Событие";
		НовыйРеквизит.Представление = НСтр("ru = 'Событие'");
		НовыйРеквизит.Тип = Новый ОписаниеТипов("ДокументСсылка.Задача,СправочникСсылка.КомментарииЗадач");
		
		НовыйРеквизит = Реквизиты.Добавить();
		НовыйРеквизит.Имя = "Автор";
		НовыйРеквизит.Представление = НСтр("ru = 'Автор'");
		НовыйРеквизит.Тип = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
		
		НовыйРеквизит = Реквизиты.Добавить();
		НовыйРеквизит.Имя = "ТекстСобытия";
		НовыйРеквизит.Представление = НСтр("ru = 'Текст события'");
		НовыйРеквизит.Тип = Новый ОписаниеТипов("Строка");
		
		
	КонецЕсли;		

КонецПроцедуры

#КонецОбласти
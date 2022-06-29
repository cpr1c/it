Функция СоответствиеНастроекАвтоформирования() Экспорт
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	НастройкиАвтоматическогоФормированияЗадач.Ссылка КАК Ссылка,
	|	НастройкиАвтоматическогоФормированияЗадач.УчетнаяЗаписьЭлектроннойПочты КАК УчетнаяЗаписьЭлектроннойПочты
	|ИЗ
	|	Справочник.НастройкиАвтоматическогоФормированияЗадач КАК НастройкиАвтоматическогоФормированияЗадач
	|ГДЕ
	|	НастройкиАвтоматическогоФормированияЗадач.Использование";
	Выборка=Запрос.Выполнить().Выбрать();

	СоответствиеФормирования=Новый Соответствие;

	Пока Выборка.Следующий() Цикл
		СоответствиеФормирования.Вставить(Выборка.УчетнаяЗаписьЭлектроннойПочты, Выборка.Ссылка);
	КонецЦикла;

	Возврат СоответствиеФормирования;
КонецФункции

Процедура АвтоматическаяПоставновкаЗадач() Экспорт

	СоответствиеНастроек=СоответствиеНастроекАвтоформирования();

	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ЭлектронноеПисьмоВходящее.Ссылка КАК Ссылка,
	|	ЭлектронноеПисьмоВходящее.УчетнаяЗапись КАК УчетнаяЗапись,
	|	ПредметыПапкиВзаимодействий.Предмет КАК Предмет,
	|	ПредметыПапкиВзаимодействий.ПапкаЭлектронногоПисьма КАК ПапкаЭлектронногоПисьма,
	|	ПредметыПапкиВзаимодействий.Рассмотрено КАК Рассмотрено,
	|	ПредметыПапкиВзаимодействий.РассмотретьПосле КАК РассмотретьПосле
	|ИЗ
	|	Документ.ЭлектронноеПисьмоВходящее КАК ЭлектронноеПисьмоВходящее
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ПО ЭлектронноеПисьмоВходящее.Ссылка = ПредметыПапкиВзаимодействий.Взаимодействие
	|ГДЕ
	|	ПредметыПапкиВзаимодействий.Рассмотрено = ЛОЖЬ";
	Выборка=Запрос.Выполнить().Выбрать();

	МассивПисемДляОбработки=Новый Массив;

	СоответствиеПисемИПапок=Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		НастройкаАвтоформирования=СоответствиеНастроек[Выборка.УчетнаяЗапись];

		Если НастройкаАвтоформирования.ПапкаЭлектроннойПочтыДляПоискаПисем <> Выборка.ПапкаЭлектронногоПисьма
			И ЗначениеЗаполнено(Выборка.ПапкаЭлектронногоПисьма) Тогда
			Продолжить;
		КонецЕсли;

		Попытка
			ОбработатьПисьмоЭлектроннойПочты(Выборка.Ссылка, НастройкаАвтоформирования);
			Папка=НастройкаАвтоформирования.ПапкаЭлектроннойПочтыДляУспешноОбработанныхПисем;
		Исключение
			Папка=НастройкаАвтоформирования.ПапкаЭлектроннойПочтыДляОшибочноОбработанныхПисем;
			
			Ошибка=ОписаниеОшибки();
			Сообщить(Ошибка);
			ЗаписьЖурналаРегистрации("Задачи.РаботаЧерезПочту", УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Документы.ЭлектронноеПисьмоВходящее, Выборка.Ссылка, Ошибка);
		КонецПопытки;

		Если СоответствиеПисемИПапок[Папка] = Неопределено Тогда
			СоответствиеПисемИПапок.Вставить(Папка, Новый Массив);
		КонецЕсли;

		СоответствиеПисемИПапок[Папка].Добавить(Выборка.Ссылка);
		МассивПисемДляОбработки.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	
	//Теперь нужно установить признак рассмотрено для этого письма
	Взаимодействия.УстановитьПризнакРассмотрено(МассивПисемДляОбработки, Истина, Истина);

	//Теперь переложим все хозяйство по папкам
	Для Каждого КлючЗначение Из СоответствиеПисемИПапок Цикл
		Взаимодействия.УстановитьПапкуДляМассиваПисем(КлючЗначение.Значение, КлючЗначение.Ключ);
	КонецЦикла;
КонецПроцедуры

Функция НайтиСуществующуюЗадачу(ТемаПисьма) Экспорт
	КомпонентаРегВыражения=РегулярныеВыраженияКлиентСервер.КомпонентаРегулярныхВыражений(Ложь, Истина, "", Ложь);

	РезультатПоиска=РегулярныеВыраженияКлиентСервер.НайтиСовпадения(ТемаПисьма, "\[*#([\d]+)*\]*",
		КомпонентаРегВыражения);

	Если РезультатПоиска = Неопределено Тогда
		Возврат Документы.Задача.ПустаяСсылка();
	КонецЕсли;

	Если РезультатПоиска.Количество() = 0 Тогда
		Возврат Документы.Задача.ПустаяСсылка();
	КонецЕсли;

	НомерЗадачиПолный=РезультатПоиска[0];
	НомерЗадачиПолный=СтрЗаменить(НомерЗадачиПолный, "#", "");
	НомерЗадачиПолный=СтрЗаменить(НомерЗадачиПолный, "[", "");
	НомерЗадачиПолный=СтрЗаменить(НомерЗадачиПолный, "]", "");

	Попытка
		НомерЗадачиПолный=Число(НомерЗадачиПолный);
	Исключение
		НомерЗадачиПолный=Неопределено;
	КонецПопытки;

	Если НомерЗадачиПолный = Неопределено Тогда
		Возврат Документы.Задача.ПустаяСсылка();
	КонецЕсли;

	Если Не ЗначениеЗаполнено(НомерЗадачиПолный) Тогда
		Возврат Документы.Задача.ПустаяСсылка();
	КонецЕсли;

	Возврат Документы.Задача.НайтиПоНомеру(НомерЗадачиПолный);
КонецФункции

Функция АвторСобытияПоПисьмуЭлектроннойПочты(СообщениеЭлектроннойПочты, НастройкаАвтоматическогоФормированияЗадач)

	Если ТипЗнч(СообщениеЭлектроннойПочты.ОтправительКонтакт) = Тип("СправочникСсылка.Пользователи") Тогда
		Автор=СообщениеЭлектроннойПочты.ОтправительКонтакт;
	ИначеЕсли ЗначениеЗаполнено(НастройкаАвтоматическогоФормированияЗадач.АвторПоУмолчанию) Тогда
		Автор=НастройкаАвтоматическогоФормированияЗадач.АвторПоУмолчанию;
	Иначе
		Автор=Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;

	Возврат Автор;

КонецФункции

Функция ТекстСообщенияHTMLЭлектроннойПочтыДляЗадачи(СообщениеЭлектроннойПочты, НастройкаАвтоматическогоФормированияЗадач)
	Если СообщениеЭлектроннойПочты.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML
		Или СообщениеЭлектроннойПочты.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTMLСКартинками Тогда
		Возврат СообщениеЭлектроннойПочты.ТекстHTML;
	Иначе
		Возврат СообщениеЭлектроннойПочты.Текст;
	КонецЕсли;
КонецФункции

Функция КонтактПоЭдресуИПредставлениюПолучателя(АдресЭлектроннойПочты, ПредставлениеКонтакта)

	КонтактыПоМылу=ФизическиеЛицаСервер.КонтактыПоEmail(АдресЭлектроннойПочты);

	Если КонтактыПоМылу.Количество() > 0 Тогда
		Возврат КонтактыПоМылу[0].Контакт;
	КонецЕсли;
	
	//Создаем контакт как новое физическое лицо
	НовыйКонтакт=Справочники.ФизическиеЛица.СоздатьЭлемент();

	ИмяКонтакта=ПредставлениеКонтакта;
	НомерСимвола=СтрНайти(ИмяКонтакта, "<");
	Если ЗначениеЗаполнено(НомерСимвола) Тогда
		ИмяКонтакта=СокрЛП(Лев(ИмяКонтакта, НомерСимвола - 1));
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ИмяКонтакта) Тогда
		ИмяКонтакта=АдресЭлектроннойПочты;
	КонецЕсли;
	НовыйКонтакт.Наименование=ИмяКонтакта;

	НоваяКИ=НовыйКонтакт.КонтактнаяИнформация.Добавить();
	НоваяКИ.Вид=Справочники.ВидыКонтактнойИнформации.EMailФизическиеЛица;
	НоваяКИ.Тип=Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	//НоваяКИ.Значение=СообщениеЭлектроннойПочты.ОтправительАдрес;
	НоваяКИ.Представление=АдресЭлектроннойПочты;
	НоваяКИ.АдресЭП=АдресЭлектроннойПочты;
	НовыйКонтакт.Записать();

	Возврат НовыйКонтакт.Ссылка;

КонецФункции

Функция КонтактСообщенияЭлектроннойПочты(СообщениеЭлектроннойПочты, НастройкаАвтоматическогоФормированияЗадач)
	Если ЗначениеЗаполнено(СообщениеЭлектроннойПочты.ОтправительКонтакт) И ТипЗнч(
		СообщениеЭлектроннойПочты.ОтправительКонтакт) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Возврат СообщениеЭлектроннойПочты.ОтправительКонтакт;
	КонецЕсли;

	Возврат КонтактПоЭдресуИПредставлениюПолучателя(СообщениеЭлектроннойПочты.ОтправительАдрес,
		СообщениеЭлектроннойПочты.ОтправительПредставление);
КонецФункции

Процедура ЗаполнитьКопииПолучателейВСобытииЗадачиПоЭлектронномуПисьму(СобытиеОбъект, СообщениеЭлектроннойПочты,
	НастройкаАвтоматическогоФормированияЗадач)
	МассивАдресов=Новый Массив;
	МассивАдресов.Добавить(НРег(СообщениеЭлектроннойПочты.УчетнаяЗапись.АдресЭлектроннойПочты));

	Если ТипЗнч(СобытиеОбъект)=Тип("ДокументОбъект.Задача") Тогда
		ТаблицаДопПолучателей=СобытиеОбъект.ПолучателиКопий;
	Иначе
		ТаблицаДопПолучателей=СобытиеОбъект.ДополнительныеПолучателиОповещения;
	КонецЕсли;

	Для Каждого СтрокаПолучателя Из СообщениеЭлектроннойПочты.ПолучателиПисьма Цикл
		Если МассивАдресов.Найти(НРег(СтрокаПолучателя.Адрес)) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Если НРег(СообщениеЭлектроннойПочты.УчетнаяЗапись.АдресЭлектроннойПочты) = СтрокаПолучателя.Адрес Тогда
			Продолжить;
		КонецЕсли;

		НоваяСтрока=ТаблицаДопПолучателей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПолучателя);

		НоваяСтрока.Контакт=КонтактПоЭдресуИПредставлениюПолучателя(СтрокаПолучателя.Адрес,
			СтрокаПолучателя.Представление);
		НоваяСтрока.Представление=ВзаимодействияКлиентСервер.ПолучитьПредставлениеАдресата(НоваяСтрока.Представление,
			НоваяСтрока.Адрес, "");

		МассивАдресов.Добавить(НРег(СтрокаПолучателя.Адрес));
	КонецЦикла;
	Для Каждого СтрокаПолучателя Из СообщениеЭлектроннойПочты.ПолучателиКопий Цикл
		Если МассивАдресов.Найти(НРег(СтрокаПолучателя.Адрес)) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если НРег(СообщениеЭлектроннойПочты.УчетнаяЗапись.АдресЭлектроннойПочты) = СтрокаПолучателя.Адрес Тогда
			Продолжить;
		КонецЕсли;

		НоваяСтрока=ТаблицаДопПолучателей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПолучателя);

		НоваяСтрока.Контакт=КонтактПоЭдресуИПредставлениюПолучателя(СтрокаПолучателя.Адрес,
			СтрокаПолучателя.Представление);
		НоваяСтрока.Представление=ВзаимодействияКлиентСервер.ПолучитьПредставлениеАдресата(НоваяСтрока.Представление,
			НоваяСтрока.Адрес, "");

		МассивАдресов.Добавить(НРег(СтрокаПолучателя.Адрес));
	КонецЦикла;
	Для Каждого СтрокаПолучателя Из СообщениеЭлектроннойПочты.ПолучателиОтвета Цикл
		Если МассивАдресов.Найти(НРег(СтрокаПолучателя.Адрес)) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если НРег(СообщениеЭлектроннойПочты.УчетнаяЗапись.АдресЭлектроннойПочты) = СтрокаПолучателя.Адрес Тогда
			Продолжить;
		КонецЕсли;

		НоваяСтрока=ТаблицаДопПолучателей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПолучателя);

		НоваяСтрока.Контакт=КонтактПоЭдресуИПредставлениюПолучателя(СтрокаПолучателя.Адрес,
			СтрокаПолучателя.Представление);
		НоваяСтрока.Представление=ВзаимодействияКлиентСервер.ПолучитьПредставлениеАдресата(НоваяСтрока.Представление,
			НоваяСтрока.Адрес, "");

		МассивАдресов.Добавить(НРег(СтрокаПолучателя.Адрес));
	КонецЦикла;
КонецПроцедуры

Процедура СкопироватьФайлыИзЭлектронногоПисьмаВСобытиеПоЗадаче(Событие, СообщениеЭлектроннойПочты,
	НастройкаАвтоматическогоФормированияЗадач)
	//Копируем файлы 
	//засовываем в присоединенные файлы вложения письма
	МассивПрисоединенныхФайлов=Новый Массив;
	РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(СообщениеЭлектроннойПочты, МассивПрисоединенныхФайлов);

	Если ТипЗнч(МассивПрисоединенныхФайлов) = Тип("Массив") Тогда
		Для Каждого ТекВложение Из МассивПрисоединенныхФайлов Цикл
			ДанныеВложения=РаботаСФайлами.ДанныеФайла(ТекВложение);

			ПараметрыФайла=Новый Структура;
			ПараметрыФайла.Вставить("Автор", Событие.Автор);
			Если ТипЗнч(Событие) = Тип("ДокументОбъект.Задача") Тогда
				ПараметрыФайла.Вставить("ВладелецФайлов", Событие.Ссылка);
				ТекстHTML=Событие.Содержание;
			Иначе
				ПараметрыФайла.Вставить("ВладелецФайлов", Событие.Задача);
				ТекстHTML=Событие.ТекстСообщения;
			КонецЕсли;
			Если ЗначениеЗаполнено(ТекВложение.ИДФайлаЭлектронногоПисьма) И СтрНайти(ТекстHTML,
				ТекВложение.ИДФайлаЭлектронногоПисьма) Тогда
				ПараметрыФайла.Вставить("ИмяБезРасширения", ТекВложение.ИДФайлаЭлектронногоПисьма);
			Иначе
				ПараметрыФайла.Вставить("ИмяБезРасширения", ДанныеВложения.Наименование);
			КонецЕсли;
			ПараметрыФайла.Вставить("РасширениеБезТочки", ДанныеВложения.Расширение);
			ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", ДанныеВложения.ДатаМодификацииУниверсальная);
			ПараметрыФайла.Вставить("РасширениеБезТочки", ДанныеВложения.Расширение);
			ПараметрыФайла.Вставить("ГруппаФайлов", Неопределено);
			ПараметрыФайла.Вставить("Служебный", Ложь);

			ВложениеСсылка=РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, ДанныеВложения.СсылкаНаДвоичныеДанныеФайла);

			УправлениеЗадачами.УстановитьПредметПрисоединенногоФайла(ВложениеСсылка, Событие);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура СоздатьНовуюЗадачуПоСообщениюЭлектроннойПочты(СообщениеЭлектроннойПочты,
	НастройкаАвтоматическогоФормированияЗадач)
	НоваяЗадача=Документы.Задача.СоздатьДокумент();
	НоваяЗадача.Дата=ТекущаяДата();

	Если ЗначениеЗаполнено(СообщениеЭлектроннойПочты.Тема) Тогда
		НоваяЗадача.Тема=СообщениеЭлектроннойПочты.Тема;
	Иначе
		НоваяЗадача.Тема="Без темы";
	КонецЕсли;

	НоваяЗадача.КонтактОбращения=КонтактСообщенияЭлектроннойПочты(СообщениеЭлектроннойПочты,
		НастройкаАвтоматическогоФормированияЗадач);
	НоваяЗадача.Автор=АвторСобытияПоПисьмуЭлектроннойПочты(СообщениеЭлектроннойПочты,
		НастройкаАвтоматическогоФормированияЗадач);

	НоваяЗадача.Статус=УправлениеЗадачамиПовтИсп.СтатусЗадачиНовый();
	НоваяЗадача.Проект=НастройкаАвтоматическогоФормированияЗадач.Проект;
	НоваяЗадача.Основание= СообщениеЭлектроннойПочты;

	НоваяЗадача.Содержание=ТекстСообщенияHTMLЭлектроннойПочтыДляЗадачи(СообщениеЭлектроннойПочты,
		НастройкаАвтоматическогоФормированияЗадач);
	НоваяЗадача.СодержаниеФормат=Перечисления.ФорматыТекстаКомментариев.HTML;

	ЗаполнитьКопииПолучателейВСобытииЗадачиПоЭлектронномуПисьму(НоваяЗадача, СообщениеЭлектроннойПочты,
		НастройкаАвтоматическогоФормированияЗадач);
	НоваяЗадача.ДополнительныеСвойства.Вставить("ЭтоИзменениеИзВнешнихИсточников", Истина);
	НоваяЗадача.Записать(РежимЗаписиДокумента.Проведение);

	СкопироватьФайлыИзЭлектронногоПисьмаВСобытиеПоЗадаче(НоваяЗадача, СообщениеЭлектроннойПочты,
		НастройкаАвтоматическогоФормированияЗадач);
КонецПроцедуры

Процедура ДобавитьКомментарийКЗадачеПоСообщениюЭлектроннойПочты(ТекущаяЗадача, СообщениеЭлектроннойПочты,
	НастройкаАвтоматическогоФормированияЗадач)
	НовыйКомментарий=Справочники.КомментарииЗадач.СоздатьЭлемент();
	НовыйКомментарий.Задача=ТекущаяЗадача;
	НовыйКомментарий.Автор=АвторСобытияПоПисьмуЭлектроннойПочты(СообщениеЭлектроннойПочты,
		НастройкаАвтоматическогоФормированияЗадач);
	НовыйКомментарий.ТекстСообщения=ТекстСообщенияHTMLЭлектроннойПочтыДляЗадачи(СообщениеЭлектроннойПочты,
		НастройкаАвтоматическогоФормированияЗадач);
	НовыйКомментарий.ТекстСообщенияФормат=Перечисления.ФорматыТекстаКомментариев.HTML;
	НовыйКомментарий.Основание=СообщениеЭлектроннойПочты;
//	НовыйКомментарий.Контакт=КонтактСообщенияЭлектроннойПочты(СообщениеЭлектроннойПочты,НастройкаАвтоматическогоФормированияЗадач);

	ЗаполнитьКопииПолучателейВСобытииЗадачиПоЭлектронномуПисьму(НовыйКомментарий, СообщениеЭлектроннойПочты,
		НастройкаАвтоматическогоФормированияЗадач);
	
	НовыйКомментарий.ДополнительныеСвойства.Вставить("ЭтоИзменениеИзВнешнихИсточников", Истина);

	НовыйКомментарий.Записать();

	СкопироватьФайлыИзЭлектронногоПисьмаВСобытиеПоЗадаче(НовыйКомментарий, СообщениеЭлектроннойПочты,
		НастройкаАвтоматическогоФормированияЗадач);
КонецПроцедуры

Процедура ОбработатьПисьмоЭлектроннойПочты(СообщениеЭлектроннойПочты, НастройкаАвтоматическогоФормированияЗадач)
	ТекущаяЗадача=НайтиСуществующуюЗадачу(СообщениеЭлектроннойПочты.Тема);

	Если ЗначениеЗаполнено(ТекущаяЗадача) Тогда
		ДобавитьКомментарийКЗадачеПоСообщениюЭлектроннойПочты(ТекущаяЗадача, СообщениеЭлектроннойПочты,
			НастройкаАвтоматическогоФормированияЗадач);
	Иначе
		СоздатьНовуюЗадачуПоСообщениюЭлектроннойПочты(СообщениеЭлектроннойПочты,
			НастройкаАвтоматическогоФормированияЗадач);
	КонецЕсли;

КонецПроцедуры
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// В локальном режиме работы возвращает регламентные задания, соответствующие отбору.
// В модели сервиса - таблицу значений, в которой содержится описание найденных заданий
// в справочниках ОчередьЗаданий (если не установлены разделители) или ОчередьЗаданийОбластейДанных.
//
// Параметры:
//  Отбор - Структура - со свойствами: 
//          1) Общие для любого режима работы:
//             * УникальныйИдентификатор - УникальныйИдентификатор - идентификатор регламентного задания
//                                            в локальном режиме работы.
//                                       - СправочникСсылка.ОчередьЗаданий,
//                                         СправочникСсылка.ОчередьЗаданийОбластейДанных - идентификатор задания
//                                            очереди в модели сервиса.
//             * Метаданные              - ОбъектМетаданных: РегламентноеЗадание - метаданные регламентного задания.
//                                       - Строка - имя регламентного задания.
//             * Использование           - Булево - если Истина, задание включено.
//             * Ключ                    - Строка - прикладной идентификатор задания.
//          2) Возможные ключи только локального режима:
//             * Наименование            - Строка - наименование регламентного задания.
//             * Предопределенное        - Булево - если Истина, регламентное задание определено в метаданных.
//          3) Возможные ключи только для модели сервиса:
//             * ИмяМетода               - Строка - имя метода (или псевдоним) обработчика очереди задании.
//             * ОбластьДанных           - Число - значение разделителя области данных задания.
//             * СостояниеЗадания        - ПеречислениеСсылка.СостоянияЗаданий - состояние задания очереди.
//             * Шаблон                  - СправочникСсылка.ШаблоныЗаданийОчереди - шаблон задания, используется только
//                                            для разделенных заданий очереди.
//
// Возвращаемое значение:
//     Массив - в локальном режиме работы массив регламентных заданий.
//              см. описание метода РегламентноеЗадание в синтакс-помощнике.
//     ТаблицаЗначений - в модели сервиса таблица значений со свойствами:
//        * ИнтервалПовтораПриАварийномЗавершении - Число - Интервал в секундах, через который нужно перезапускать
//                                                     задание в случае его аварийного завершения.
//        * Использование                         - Булево - если Истина, задание включено.
//        * Ключ                                  - Строка - прикладной идентификатор задания.
//        * КоличествоПовторовПриАварийномЗавершении - Число - количество повторов при аварийном завершении задания.
//        * Параметры                             - Массив - параметры, передаваемые в обработчик задания.
//        * Расписание                            - Расписание - расписание задания.
//        * УникальныйИдентификатор               - УникальныйИдентификатор - идентификатор регламентного задания
//                                                     в локальном режиме работы.
//                                                - СправочникСсылка.ОчередьЗаданий,
//                                                  СправочникСсылка.ОчередьЗаданийОбластейДанных - идентификатор задания
//                                                     очереди в модели сервиса.
//        * ЗапланированныйМоментЗапуска          - Дата - дата и время запланированного запуска задания
//                                                     (в часовом поясе области данных).
//        * ИмяМетода                             - Строка - имя метода (или псевдоним) обработчика очереди задании.
//        * ОбластьДанных                         - Число - значение разделителя области данных задания.
//        * СостояниеЗадания                      - ПеречислениеСсылка.СостоянияЗаданий - состояние задания очереди.
//        * Шаблон                                - СправочникСсылка.ШаблоныЗаданийОчереди - шаблон задания,
//                                                     используется только для разделенных заданий очереди.
//        * ЭксклюзивноеВыполнение                - Булево - при установленном флаге задание будет выполнено 
//                                                     даже при установленной блокировке начала сеансов в области
//                                                     данных. Так же если в области есть задания с таким флагом
//                                                     сначала будут выполнены они.
//
Функция НайтиЗадания(Отбор) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	
	КопияОтбора = ОбщегоНазначения.СкопироватьРекурсивно(Отбор);
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ОчередьЗаданий") Тогда
			
			Если КопияОтбора.Свойство("УникальныйИдентификатор") И НЕ КопияОтбора.Свойство("Идентификатор") Тогда
				КопияОтбора.Вставить("Идентификатор", КопияОтбора.УникальныйИдентификатор);
			КонецЕсли;
			
			Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
				ОбластьДанных = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
				КопияОтбора.Вставить("ОбластьДанных", ОбластьДанных);
			КонецЕсли;
			
			МодульОчередьЗаданий  = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			ШаблоныЗаданийОчереди = МодульОчередьЗаданий.ШаблоныЗаданийОчереди();
			
			Если КопияОтбора.Свойство("Метаданные") Тогда
				Если ТипЗнч(КопияОтбора.Метаданные) = Тип("ОбъектМетаданных") Тогда
					Если ШаблоныЗаданийОчереди.Найти(КопияОтбора.Метаданные.Имя) <> Неопределено Тогда
						УстановитьПривилегированныйРежим(Истина);
						Шаблон = МодульОчередьЗаданий.ШаблонПоИмени(КопияОтбора.Метаданные.Имя);
						УстановитьПривилегированныйРежим(Ложь);
						КопияОтбора.Вставить("Шаблон", Шаблон);
					Иначе
						КопияОтбора.Вставить("ИмяМетода", КопияОтбора.Метаданные.ИмяМетода);
					КонецЕсли;
				Иначе
					МетаданныеРегламентноеЗадание = Метаданные.РегламентныеЗадания.Найти(КопияОтбора.Метаданные);
					Если МетаданныеРегламентноеЗадание <> Неопределено Тогда
						Если ШаблоныЗаданийОчереди.Найти(МетаданныеРегламентноеЗадание.Имя) <> Неопределено Тогда
							УстановитьПривилегированныйРежим(Истина);
							Шаблон = МодульОчередьЗаданий.ШаблонПоИмени(МетаданныеРегламентноеЗадание.Имя);
							УстановитьПривилегированныйРежим(Ложь);
							КопияОтбора.Вставить("Шаблон", Шаблон);
						Иначе
							КопияОтбора.Вставить("ИмяМетода", МетаданныеРегламентноеЗадание.ИмяМетода);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			ИначеЕсли КопияОтбора.Свойство("Идентификатор") 
				И (ТипЗнч(КопияОтбора.Идентификатор) = Тип("УникальныйИдентификатор")
				ИЛИ ТипЗнч(КопияОтбора.Идентификатор) = Тип("Строка")) Тогда
				
				Если ТипЗнч(КопияОтбора.Идентификатор) = Тип("Строка") Тогда
					КопияОтбора.Идентификатор = Новый УникальныйИдентификатор(КопияОтбора.Идентификатор);
				КонецЕсли;
				
				СправочникДляЗадания = МодульОчередьЗаданий.СправочникОчередьЗаданий();
				Если МодульРаботаВМоделиСервиса.ЭтоРазделеннаяКонфигурация() Тогда
					МодульОчередьЗаданийРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийРазделениеДанных");
					ПереопределенныйСправочник = МодульОчередьЗаданийРазделениеДанных.ПриВыбореСправочникаДляЗадания(КопияОтбора);
					Если ПереопределенныйСправочник <> Неопределено Тогда
						СправочникДляЗадания = ПереопределенныйСправочник;
					КонецЕсли;
				КонецЕсли;
				КопияОтбора.Вставить("Идентификатор", СправочникДляЗадания.ПолучитьСсылку(КопияОтбора.Идентификатор));
			КонецЕсли;
			
			КопияОтбора.Удалить("Метаданные");
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(КопияОтбора);
			// Для обратной совместимости поле Идентификатор не удаляется.
			КопияСписка = СписокЗаданий.Скопировать();
			КопияСписка.Колонки.Добавить("УникальныйИдентификатор");
			Для Каждого Строка Из КопияСписка Цикл
				Строка.УникальныйИдентификатор = Строка.Идентификатор;
			КонецЦикла;
			
			Возврат КопияСписка;
			
		КонецЕсли;
	Иначе
		
		СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(КопияОтбора);
		
		Возврат СписокЗаданий;
		
	КонецЕсли;
	
КонецФункции

// Возвращает РегламентноеЗадание из информационной базы.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания 
//                           или имя метаданных предопределенного регламентного задания.
//                - РегламентноеЗадание - регламентное задание из которого нужно получить
//                  уникальный идентификатор для получения свежей копии регламентного задания.
// 
// Возвращаемое значение:
//  РегламентноеЗадание - прочитано из базы данных.
//
Функция Задание(Знач Идентификатор) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ОчередьЗаданий") Тогда
			МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
			
			ПараметрыЗадания = Новый Структура;
			Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
				ОбластьДанных = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
				ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
			КонецЕсли;
			
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			
			Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
				Если Идентификатор.Предопределенное Тогда
					УстановитьПривилегированныйРежим(Истина);
					ПараметрыЗадания.Вставить("Шаблон", МодульОчередьЗаданий.ШаблонПоИмени(Идентификатор.Имя));
					УстановитьПривилегированныйРежим(Ложь);
				Иначе
					ПараметрыЗадания.Вставить("ИмяМетода", Идентификатор.ИмяМетода);
				КонецЕсли; 
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("УникальныйИдентификатор") Тогда
				СправочникДляЗадания = МодульОчередьЗаданий.СправочникОчередьЗаданий();
				Если МодульРаботаВМоделиСервиса.ЭтоРазделеннаяКонфигурация() Тогда
					МодульОчередьЗаданийРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийРазделениеДанных");
					ПереопределенныйСправочник = МодульОчередьЗаданийРазделениеДанных.ПриВыбореСправочникаДляЗадания(ПараметрыЗадания);
					Если ПереопределенныйСправочник <> Неопределено Тогда
						СправочникДляЗадания = ПереопределенныйСправочник;
					КонецЕсли;
				КонецЕсли;
				ПараметрыЗадания.Вставить("Идентификатор", СправочникДляЗадания.ПолучитьСсылку(Идентификатор));
				
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("СтрокаТаблицыЗначений") Тогда
				Возврат Идентификатор;
			Иначе
				ПараметрыЗадания.Вставить("Идентификатор", Идентификатор);
			КонецЕсли;
			
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Для Каждого Задание Из СписокЗаданий Цикл
				РегламентноеЗадание = Задание;
				Прервать;
			КонецЦикла;
		КонецЕсли;
	Иначе
		
		Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
			Если Идентификатор.Предопределенное Тогда
				РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Идентификатор);
			Иначе
				СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", Идентификатор));
				Если СписокЗаданий.Количество() > 0 Тогда
					РегламентноеЗадание = СписокЗаданий[0];
				КонецЕсли;
			КонецЕсли; 
		Иначе
			РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
		КонецЕсли;
	КонецЕсли;
	
	Возврат РегламентноеЗадание;
	
КонецФункции

// Добавляет новое задание в очередь или как регламентное.
// 
// Параметры: 
//  Параметры - Структура - Параметры добавляемого задания, возможные ключи:
//   * Использование
//   * Метаданные - обязательно для указания
//   * Параметры
//   * Ключ
//   * ИнтервалПовтораПриАварийномЗавершении
//   * Расписание
//   * КоличествоПовторовПриАварийномЗавершении
//
// Возвращаемое значение: 
//  РегламентноеЗадание, СправочникСсылка.ОчередьЗаданий, СправочникСсылка.ОчередьЗаданийОбластейДанных - идентификатор
//  добавленного задания.
// 
Функция ДобавитьЗадание(Параметры) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	
	ПараметрыЗадания = ОбщегоНазначения.СкопироватьРекурсивно(Параметры);
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ОчередьЗаданий") Тогда
			
			Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
				МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
				ОбластьДанных = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
				ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
			КонецЕсли;
			
			МетаданныеЗадания = ПараметрыЗадания.Метаданные;
			ИмяМетода = МетаданныеЗадания.ИмяМетода;
			ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
			
			ПараметрыЗадания.Удалить("Метаданные");
			ПараметрыЗадания.Удалить("Наименование");
			
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			Задание = МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(Новый Структура("Идентификатор", Задание));
			Для Каждого Задание Из СписокЗаданий Цикл
				Возврат Задание;
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		
		МетаданныеЗадания = ПараметрыЗадания.Метаданные;
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(МетаданныеЗадания);
		
		Если ПараметрыЗадания.Свойство("Наименование") Тогда
			Задание.Наименование = ПараметрыЗадания.Наименование;
		Иначе
			Задание.Наименование = МетаданныеЗадания.Наименование;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Использование") Тогда
			Задание.Использование = ПараметрыЗадания.Использование;
		Иначе
			Задание.Использование = МетаданныеЗадания.Использование;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Ключ") Тогда
			Задание.Ключ = ПараметрыЗадания.Ключ;
		Иначе
			Задание.Ключ = МетаданныеЗадания.Ключ;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("ИмяПользователя") Тогда
			Задание.ИмяПользователя = ПараметрыЗадания.ИмяПользователя;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("ИнтервалПовтораПриАварийномЗавершении") Тогда
			Задание.ИнтервалПовтораПриАварийномЗавершении = ПараметрыЗадания.ИнтервалПовтораПриАварийномЗавершении;
		Иначе
			Задание.ИнтервалПовтораПриАварийномЗавершении = МетаданныеЗадания.ИнтервалПовтораПриАварийномЗавершении;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("КоличествоПовторовПриАварийномЗавершении") Тогда
			Задание.КоличествоПовторовПриАварийномЗавершении = ПараметрыЗадания.КоличествоПовторовПриАварийномЗавершении;
		Иначе
			Задание.КоличествоПовторовПриАварийномЗавершении = МетаданныеЗадания.КоличествоПовторовПриАварийномЗавершении;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Параметры") Тогда
			Задание.Параметры = ПараметрыЗадания.Параметры;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Расписание") Тогда
			Задание.Расписание = ПараметрыЗадания.Расписание;
		КонецЕсли;
		
		Задание.Записать();
		
	КонецЕсли;
	
	Возврат Задание;
	
КонецФункции

// Удаляет РегламентноеЗадание из информационной базы.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  не предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание, которое нужно получить
//                  уникальный идентификатор для получения свежей копии регламентного задания.
//
Процедура УдалитьЗадание(Знач Идентификатор) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ОчередьЗаданий") Тогда
			МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
			
			ПараметрыЗадания = Новый Структура;
			Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
				ОбластьДанных = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
				ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
			КонецЕсли;
			
			Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
				ИмяМетода = Идентификатор.ИмяМетода;
				ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("УникальныйИдентификатор") Тогда
				МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
				СправочникДляЗадания = МодульОчередьЗаданий.СправочникОчередьЗаданий();
				
				Если МодульРаботаВМоделиСервиса.ЭтоРазделеннаяКонфигурация() Тогда
					МодульОчередьЗаданийРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийРазделениеДанных");
					ПереопределенныйСправочник = МодульОчередьЗаданийРазделениеДанных.ПриВыбореСправочникаДляЗадания(ПараметрыЗадания);
					Если ПереопределенныйСправочник <> Неопределено Тогда
						СправочникДляЗадания = ПереопределенныйСправочник;
					КонецЕсли;
				КонецЕсли;
				
				ПараметрыЗадания.Вставить("Идентификатор", СправочникДляЗадания.ПолучитьСсылку(Идентификатор));
				
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("СтрокаТаблицыЗначений") Тогда
				
				МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
				МодульОчередьЗаданий.УдалитьЗадание(Идентификатор.Идентификатор);
				Возврат;
				
			Иначе
				ПараметрыЗадания.Вставить("Идентификатор", Идентификатор);
			КонецЕсли;
			
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Для Каждого Задание Из СписокЗаданий Цикл
				МодульОчередьЗаданий.УдалитьЗадание(Задание.Идентификатор);
			КонецЦикла;
		КонецЕсли;
	Иначе
		Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И Идентификатор.Предопределенное Тогда
			ВызватьИсключение( НСтр("ru = 'Предопределенное регламентное задание удалить невозможно.'") );
		ИначеЕсли ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И НЕ Идентификатор.Предопределенное Тогда
			СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", Идентификатор));
			Для каждого РегламентноеЗадание Из СписокЗаданий Цикл
				РегламентноеЗадание.Удалить();
			КонецЦикла; 
		Иначе
			РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
			Если РегламентноеЗадание <> Неопределено Тогда
				РегламентноеЗадание.Удалить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Изменяет задание с указанным идентификатором.
// В случае вызова в транзакции на задание устанавливается объектная блокировка.
// 
// Параметры: 
//  Идентификатор - СправочникСсылка.ОчередьЗаданий, СправочникСсылка.ОчередьЗаданийОбластейДанных - идентификатор задания
//  Параметры     - Структура - Параметры, которые следует установить заданию, возможные ключи:
//   * Использование
//   * Параметры
//   * Ключ
//   * ИнтервалПовтораПриАварийномЗавершении
//   * Расписание
//   * КоличествоПовторовПриАварийномЗавершении
//   
//   В случае если задание создано на основе шаблона или предопределенное, могут быть указаны
//   только следующие ключи: Использование.
// 
Процедура ИзменитьЗадание(Знач Идентификатор, Знач Параметры) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	
	ПараметрыЗадания = ОбщегоНазначения.СкопироватьРекурсивно(Параметры);
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ОчередьЗаданий") Тогда
			МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
			
			ПараметрыПоиска = Новый Структура;
			
			ПараметрыЗадания.Удалить("Наименование");
			Если ПараметрыЗадания.Количество() = 0 Тогда
				Возврат;
			КонецЕсли; 
			
			Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
				ОбластьДанных = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
				ПараметрыПоиска.Вставить("ОбластьДанных", ОбластьДанных);
			КонецЕсли;
			
			Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
				ИмяМетода = Идентификатор.ИмяМетода;
				ПараметрыПоиска.Вставить("ИмяМетода", ИмяМетода);
				
				// Если рег.задание предопределенное и есть шаблон очереди - можно изменять только "Использование".
				Если Идентификатор.Предопределенное Тогда
					
					МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
					Шаблоны = МодульОчередьЗаданий.ШаблоныЗаданийОчереди();
					
					Если Шаблоны.Найти(Идентификатор.Имя) <> Неопределено 
						И (ПараметрыЗадания.Количество() > 1 
						ИЛИ НЕ ПараметрыЗадания.Свойство("Использование")) Тогда
						
						Для каждого ПараметрЗадания Из ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыЗадания) Цикл
							
							Если ПараметрЗадания.Ключ = "Использование" Тогда
								Продолжить;
							КонецЕсли;
							
							ПараметрыЗадания.Удалить(ПараметрЗадания.Ключ);
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;
				
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("УникальныйИдентификатор") Тогда
				МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
				СправочникДляЗадания = МодульОчередьЗаданий.СправочникОчередьЗаданий();
				Если МодульРаботаВМоделиСервиса.ЭтоРазделеннаяКонфигурация() Тогда
					МодульОчередьЗаданийРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийРазделениеДанных");
					ПереопределенныйСправочник = МодульОчередьЗаданийРазделениеДанных.ПриВыбореСправочникаДляЗадания(ПараметрыПоиска);
					Если ПереопределенныйСправочник <> Неопределено Тогда
						СправочникДляЗадания = ПереопределенныйСправочник;
					КонецЕсли;
				КонецЕсли;
				
				ПараметрыПоиска.Вставить("Идентификатор", СправочникДляЗадания.ПолучитьСсылку(Идентификатор));
				
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("СтрокаТаблицыЗначений") Тогда
				
				Если ЗначениеЗаполнено(Идентификатор.Шаблон)
					И (ПараметрыЗадания.Количество() > 1 
					ИЛИ НЕ ПараметрыЗадания.Свойство("Использование")) Тогда
					
					Для Каждого ПараметрЗадания Из ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыЗадания) Цикл
						
						Если ПараметрЗадания.Ключ = "Использование" Тогда
							Продолжить;
						КонецЕсли;
						
						ПараметрыЗадания.Удалить(ПараметрЗадания.Ключ);
					КонецЦикла;
				КонецЕсли;
				
				Если ПараметрыЗадания.Количество() = 0 Тогда
					Возврат;
				КонецЕсли;
				
				МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
				МодульОчередьЗаданий.ИзменитьЗадание(Идентификатор.Идентификатор, ПараметрыЗадания);
				Возврат;
				
			Иначе
				ПараметрыПоиска.Вставить("Идентификатор", Идентификатор);
			КонецЕсли;
			
			Если ПараметрыЗадания.Количество() = 0 Тогда
				Возврат;
			КонецЕсли;
			
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыПоиска);
			Для Каждого Задание Из СписокЗаданий Цикл
				МодульОчередьЗаданий.ИзменитьЗадание(Задание.Идентификатор, ПараметрыЗадания);
			КонецЦикла;
		КонецЕсли;
		
	Иначе
		
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
		Если Задание <> Неопределено Тогда
			
			Если ПараметрыЗадания.Свойство("Наименование") Тогда
				Задание.Наименование = ПараметрыЗадания.Наименование;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("Использование") Тогда
				Задание.Использование = ПараметрыЗадания.Использование;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("Ключ") Тогда
				Задание.Ключ = ПараметрыЗадания.Ключ;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("ИмяПользователя") Тогда
				Задание.ИмяПользователя = ПараметрыЗадания.ИмяПользователя;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("ИнтервалПовтораПриАварийномЗавершении") Тогда
				Задание.ИнтервалПовтораПриАварийномЗавершении = ПараметрыЗадания.ИнтервалПовтораПриАварийномЗавершении;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("КоличествоПовторовПриАварийномЗавершении") Тогда
				Задание.КоличествоПовторовПриАварийномЗавершении = ПараметрыЗадания.КоличествоПовторовПриАварийномЗавершении;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("Параметры") Тогда
				Задание.Параметры = ПараметрыЗадания.Параметры;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("Расписание") Тогда
				Задание.Расписание = ПараметрыЗадания.Расписание;
			КонецЕсли;
			
			Задание.Записать();
		
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает уникальный идентификатор регламентного задания.
//  Перед вызовом требуется иметь право администрирования или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
// Возвращаемое значение:
//  УникальныйИдентификатор - УИ объекта регламентного задания.
// 
Функция УникальныйИдентификатор(Знач Идентификатор) Экспорт
	
	Если ТипЗнч(Идентификатор) = Тип("УникальныйИдентификатор") Тогда
		Возврат Идентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Возврат Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Возврат Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		ПараметрыЗадания = Новый Структура;
		
		ИдентификаторТипЗнч = ТипЗнч(Идентификатор);
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		
		Если ИдентификаторТипЗнч = Тип("ОбъектМетаданных") Тогда
			ИмяМетода = Идентификатор.ИмяМетода;
			ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
		ИначеЕсли ИдентификаторТипЗнч = Тип("СтрокаТаблицыЗначений") Тогда
			Возврат Идентификатор.Идентификатор.УникальныйИдентификатор();
		ИначеЕсли ОбщегоНазначения.ЭтоСсылка(ИдентификаторТипЗнч) Тогда
			Возврат Идентификатор.УникальныйИдентификатор();
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		ОбластьДанных = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ОчередьЗаданий") Тогда
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Для Каждого Задание Из СписокЗаданий Цикл
				Возврат Задание.Идентификатор.УникальныйИдентификатор();
			КонецЦикла;
		КонецЕсли;
	Иначе
		Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И Идентификатор.Предопределенное Тогда
			Возврат РегламентныеЗадания.НайтиПредопределенное(Идентификатор).УникальныйИдентификатор;
		ИначеЕсли ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И НЕ Идентификатор.Предопределенное Тогда
			СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", Идентификатор));
			Для каждого РегламентноеЗадание Из СписокЗаданий Цикл
				Возврат РегламентноеЗадание.УникальныйИдентификатор;
			КонецЦикла; 
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции без поддержки модели сервиса.

// Возвращает использование регламентного задания.
// Перед вызовом требуется иметь право администрирования или УстановитьПривилегированныйРежим.
// Не предназначена для использования в модели сервиса.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
// Возвращаемое значение:
//  Булево - если Истина, регламентное задание используется.
// 
Функция РегламентноеЗаданиеИспользуется(Знач Идентификатор) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Возврат Задание.Использование;
	
КонецФункции

// Возвращает расписание регламентного задания.
// Перед вызовом требуется иметь право администрирования или УстановитьПривилегированныйРежим.
// Не предназначена для использования в модели сервиса.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
//  ВСтруктуре    - Булево - если Истина, тогда расписание будет преобразовано
//                  в структуру, которую можно передать на клиент.
// 
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания, Структура - структура содержит те же свойства, что и расписание.
// 
Функция РасписаниеРегламентногоЗадания(Знач Идентификатор, Знач ВСтруктуре = Ложь) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если ВСтруктуре Тогда
		Возврат ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Задание.Расписание);
	КонецЕсли;
	
	Возврат Задание.Расписание;
	
КонецФункции

// Устанавливает использование регламентного задания.
// Перед вызовом требуется иметь право администрирования или УстановитьПривилегированныйРежим.
// Не предназначена для использования в модели сервиса.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных        - объект метаданных регламентного задания для поиска
//                                            предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка                  - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание     - регламентное задание.
//  Использование - Булево                  - значение использования которое нужно установить.
//
Процедура УстановитьИспользованиеРегламентногоЗадания(Знач Идентификатор, Знач Использование) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если Задание.Использование <> Использование Тогда
		Задание.Использование = Использование;
	КонецЕсли;
	
	Задание.Записать();
	
КонецПроцедуры

// Устанавливает расписание регламентного задания.
// Перед вызовом требуется иметь право администрирования или УстановитьПривилегированныйРежим.
// Не предназначена для использования в модели сервиса.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
//  Расписание    - РасписаниеРегламентногоЗадания - расписание.
//                - Структура - значение возвращаемое функцией РасписаниеВСтруктуру
//                  общего модуля ОбщегоНазначенияКлиентСервер.
// 
Процедура УстановитьРасписаниеРегламентногоЗадания(Знач Идентификатор, Знач Расписание) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если ТипЗнч(Расписание) = Тип("РасписаниеРегламентногоЗадания") Тогда
		Задание.Расписание = Расписание;
	Иначе
		Задание.Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание);
	КонецЕсли;
	
	Задание.Записать();
	
КонецПроцедуры

// Возвращает РегламентноеЗадание из информационной базы.
// Не предназначена для использования в модели сервиса.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание из которого нужно получить
//                  уникальный идентификатор для получения свежей копии регламентного задания.
// 
// Возвращаемое значение:
//  РегламентноеЗадание - прочитано из базы данных.
//
Функция ПолучитьРегламентноеЗадание(Знач Идентификатор) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
		РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Идентификатор);
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	КонецЕсли;
	
	Если РегламентноеЗадание = Неопределено Тогда
		ВызватьИсключение( НСтр("ru = 'Регламентное задание не найдено.
		                              |Возможно, оно удалено другим пользователем.'") );
	КонецЕсли;
	
	Возврат РегламентноеЗадание;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции.

// Возвращает признак установленной блокировки работы с внешними ресурсами.
//
// Возвращаемое значение:
//   Булево   - Истина, если работа с внешними ресурсами заблокирована.
//
Функция РаботаСВнешнимиРесурсамиЗаблокирована() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		МодульБлокировкаРаботыСВнешнимиРесурсами = ОбщегоНазначения.ОбщийМодуль("БлокировкаРаботыСВнешнимиРесурсами");
		Возврат МодульБлокировкаРаботыСВнешнимиРесурсами.РаботаСВнешнимиРесурсамиЗаблокирована();
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Разрешает работу с внешними ресурсами.
//
Процедура РазблокироватьРаботуСВнешнимиРесурсами() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		МодульБлокировкаРаботыСВнешнимиРесурсами = ОбщегоНазначения.ОбщийМодуль("БлокировкаРаботыСВнешнимиРесурсами");
		МодульБлокировкаРаботыСВнешнимиРесурсами.РазрешитьРаботуСВнешнимиРесурсами();
	КонецЕсли;
	
КонецПроцедуры

// Запрещает работу с внешними ресурсами.
//
Процедура ЗаблокироватьРаботуСВнешнимиРесурсами() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		МодульБлокировкаРаботыСВнешнимиРесурсами = ОбщегоНазначения.ОбщийМодуль("БлокировкаРаботыСВнешнимиРесурсами");
		МодульБлокировкаРаботыСВнешнимиРесурсами.ЗапретитьРаботуСВнешнимиРесурсами();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает требуемые значения параметров регламентного задания.
// В модели сервиса для задания, созданного на основе шаблона очереди заданий,
// может быть изменено только значение свойства Использование.
//
// Параметры:
//  РегламентноеЗадание - ОбъектМетаданных: РегламентноеЗадание - задание, свойства которого
//                        требуется изменить.
//  ИзменяемыеПараметры - Структура - свойства регламентного задания, которые требуется изменить.
//                        Ключ структуры - имя параметра, а значение - значение параметра формы.
//  Отбор               - Структура - см. описание параметра Отбор функции НайтиЗадания.
//
Процедура УстановитьПараметрыРегламентногоЗадания(РегламентноеЗадание, ИзменяемыеПараметры, Отбор = Неопределено) Экспорт
	
	Если Отбор = Неопределено Тогда
		Отбор = Новый Структура;
	КонецЕсли;
	Отбор.Вставить("Метаданные", РегламентноеЗадание);
	
	СписокЗаданий = НайтиЗадания(Отбор);
	Если СписокЗаданий.Количество() = 0 Тогда
		ИзменяемыеПараметры.Вставить("Метаданные", РегламентноеЗадание);
		ДобавитьЗадание(ИзменяемыеПараметры);
	Иначе
		Для Каждого Задание Из СписокЗаданий Цикл
			ИзменитьЗадание(Задание, ИзменяемыеПараметры);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Устанавливает использование предопределенного регламентного задания.
//
// Параметры:
//  ЗаданиеМетаданные - ОбъектМетаданных - метаданные предопределенного регламентного задания.
//  Использование     - Булево - Истина, если задание нужно включить, иначе Ложь.
//
Процедура УстановитьИспользованиеПредопределенногоРегламентногоЗадания(ЗаданиеМетаданные, Использование) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Отбор     = Новый Структура;
		Отбор.Вставить("Метаданные", ЗаданиеМетаданные);
		Параметры = Новый Структура;
		Параметры.Вставить("Использование", Истина);
		Задания = НайтиЗадания(Отбор);
		Для Каждого Задание Из Задания Цикл
			ИзменитьЗадание(Задание.УникальныйИдентификатор, Параметры);
			Прервать;
		КонецЦикла;
	Иначе
		Задание = РегламентныеЗадания.НайтиПредопределенное(ЗаданиеМетаданные);
		
		Если Задание.Использование <> Использование Тогда
			Задание.Использование = Использование;
			Задание.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывает исключение, если у пользователя нет права администрирования.
Процедура ВызватьИсключениеЕслиНетПраваАдминистрирования()
	
	ПроверятьПраваАдминистрированияСистемы = Истина;
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		ПроверятьПраваАдминистрированияСистемы = Ложь;
	КонецЕсли;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, ПроверятьПраваАдминистрированияСистемы) Тогда
		ВызватьИсключение НСтр("ru = 'Нарушение прав доступа.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
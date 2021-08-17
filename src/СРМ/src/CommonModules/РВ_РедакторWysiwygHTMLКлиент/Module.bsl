#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

Процедура ДокументСформированПоляРедактированияКомментария(Форма, Элемент) Экспорт
	ПутьКДанным=РВ_РедакторWysiwygHTMLКлиентСервер.ПолучитьПутьКДаннымПоИмениПоляРедактирования(Элемент.Имя);
	
	ОбновитьПолеРедактированияКомментария(Форма, ПутьКДанным);
КонецПроцедуры

Процедура ОткрытьПрисоединенныйФайл(Форма, Команда) Экспорт
	МассивНаименования=СтрРазделить(Команда.Имя, "_");
	ИдентификаторСтроки = Число(МассивНаименования[3]);

	МассивНаименования.Удалить(0);
	МассивНаименования.Удалить(0);
	МассивНаименования.Удалить(0);
	МассивНаименования.Удалить(0);

	ПутьКДаннымБезЛишнего= СтрСоединить(МассивНаименования, "_");

	ИмяТаблицыФайлов=РВ_РедакторWysiwygHTMLКлиентСервер.ИмяТаблицыПрисоединенныхФайлов(ПутьКДаннымБезЛишнего);
	СтрокаФайла = Форма[ИмяТаблицыФайлов].НайтиПоИдентификатору(ИдентификаторСтроки);
	НачатьЗапускПриложения(ПустоеОписаниеОповещенияДляЗапускаПриложения(), СтрокаФайла.ПутьКФайлу);

КонецПроцедуры

Процедура УдалитьНовыйПрисоединенныйФайл(Форма, Команда) Экспорт

	МассивНаименования=СтрРазделить(Команда.Имя, "_");
	ИдентификаторСтроки = Число(МассивНаименования[3]);

	МассивНаименования.Удалить(0);
	МассивНаименования.Удалить(0);
	МассивНаименования.Удалить(0);
	МассивНаименования.Удалить(0);

	ПутьКДаннымБезЛишнего=СтрСоединить(МассивНаименования, "_");

	Элементы = Форма.Элементы;

	ИмяГруппыФайла=РВ_РедакторWysiwygHTMLКлиентСервер.ИмяГруппыНовогоПрисоединеногоФайла(ПутьКДаннымБезЛишнего,
		ИдентификаторСтроки);
	ГруппаПрисоединенногоФайла = Элементы.Найти(ИмяГруппыФайла);
	Если ГруппаПрисоединенногоФайла <> Неопределено Тогда
		ГруппаПрисоединенногоФайла.Видимость = Ложь;
	КонецЕсли;

	ИмяТаблицыПрисоединенныхФайлов=РВ_РедакторWysiwygHTMLКлиентСервер.ИмяТаблицыПрисоединенныхФайлов(ПутьКДаннымБезЛишнего);
	СтрокаФайла = Форма[ИмяТаблицыПрисоединенныхФайлов].НайтиПоИдентификатору(ИдентификаторСтроки);
	СтрокаФайла.ПутьКФайлу = "";
	СтрокаФайла.ИмяФайла = "";
	СтрокаФайла.Адрес = "";
	
	//Делаем невидимым кнопку вставить
	ИмяКомандыВставить=РВ_РедакторWysiwygHTMLКлиентСервер.ИмяКомандыВставитьНовогоПрисоединеногоФайла(ПутьКДаннымБезЛишнего,
		ИдентификаторСтроки);
	КнопкаВставить=Элементы.Найти(ИмяКомандыВставить);
	Если КнопкаВставить <> Неопределено Тогда
		КнопкаВставить.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура ДокументПриНажатииПоляРедактированияКомментария(Форма, Элемент, ДанныеСобытия, СтандартнаяОбработка) Экспорт
	Если ДанныеСобытия.element.id<>"interactionButton" Тогда
		Возврат;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	
	ПутьКДанным=РВ_РедакторWysiwygHTMLКлиентСервер.ПолучитьПутьКДаннымПоИмениПоляРедактирования(Элемент.Имя);
	ПутьКДаннымБезЛишнего = РВ_РедакторWysiwygHTMLКлиентСервер.ПолучитьПутьКДаннымБезЛишнего(ПутьКДанным);
	
	Событие = ДанныеСобытия.Document.defaultView.eventTo1C;
	
	Если Событие.name="uploadFile" Тогда
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ФормаВладелец", Форма);
		ПараметрыВыполнения.Вставить("ПутьКДаннымБезЛишнего", ПутьКДаннымБезЛишнего);
		
		ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Обработчик = Новый ОписаниеОповещения("ДобавитьИзФайловойСистемыБезРасширенияПослеЗагрузкиФайла", ЭтотОбъект,
			ПараметрыВыполнения);
		НачатьПомещениеФайла(Обработчик, , ДиалогВыбора, , Форма.УникальныйИдентификатор);
		
	ИначеЕсли Событие.name="clipImage" Тогда
		#Если Не ВебКлиент Тогда
			ДопПараметры=Новый Структура;
			ДопПараметры.Вставить("Форма",Форма);
			ДопПараметры.Вставить("ПутьКДаннымБезЛишнего",ПутьКДаннымБезЛишнего);
			РМ_БуферОбменаКлиент.НачатьПолучениеКартинкиИзБуфера(Новый ОписаниеОповещения("КомандаВставитьИзображениеИзБуфераОбменаЗавершение",ЭтотОбъект,ДопПараметры),"ДвоичныеДанные");
		#КонецЕсли
		
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьЗначениеПоляРедактированияВРеквизит(Форма, ПутьКДанным) Экспорт
	ПутьКДаннымБезЛишнего=РВ_РедакторWysiwygHTMLКлиентСервер.ПолучитьПутьКДаннымБезЛишнего(ПутьКДанным);
	
	ИмяЭлементаПоляКоментария=РВ_РедакторWysiwygHTMLКлиентСервер.ПолучитьИмяЭлементаРедактированияКомментария(ПутьКДанным);
	
	ТекстКомментария=Форма.Элементы[ИмяЭлементаПоляКоментария].Документ.defaultView.appTo1C.getHtmlText();
	
	ДанныеПрисоединенныхФайлов = РВ_РедакторWysiwygHTMLКлиентСервер.ДанныеПрисоединенныхФайлов(Форма, ПутьКДаннымБезЛишнего);
	
	Для Каждого СтрокаФайла Из ДанныеПрисоединенныхФайлов Цикл
		Если не ЗначениеЗаполнено(СтрокаФайла.Адрес)Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаФайла.ЭтоНовый Тогда
			ЧастиИмениФайла = РВ_РедакторWysiwygHTMLКлиентСервер.РазложитьПолноеИмяФайла(СтрокаФайла.ПутьКФайлу);
			РасширениеБезТочки = СтрЗаменить(ЧастиИмениФайла.Расширение, ".", "");
			ИмяБезРасширения = ЧастиИмениФайла.ИмяБезРасширения;
		Иначе
			ИмяБезРасширения=Строка(СтрокаФайла.Ссылка);
		КонецЕсли;
		ТекстКомментария=СтрЗаменить(ТекстКомментария,"src="""+СтрокаФайла.Адрес+"""","src=""cid:"+ИмяБезРасширения+"""");
	КонецЦикла;
	
	РВ_РедакторWysiwygHTMLКлиентСервер.УстановитьТекстКомментария(Форма,ПутьКДанным,ТекстКомментария);

КонецПроцедуры

#КонецОбласти

Функция ПустоеОписаниеОповещенияДляЗапускаПриложения() Экспорт
	Возврат Новый ОписаниеОповещения("НачатьЗапускПриложенияЗавершениеПустое", ЭтотОбъект);
КонецФункции

Процедура НачатьЗапускПриложенияЗавершениеПустое(КодВозврата, ДополнительныеПараметры) Экспорт
	Если КодВозврата = Неопределено Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

Процедура ОбновитьПолеРедактированияКомментария(Форма, ПутьКДанным) Экспорт
	ПутьКДаннымБезЛишнего=РВ_РедакторWysiwygHTMLКлиентСервер.ПолучитьПутьКДаннымБезЛишнего(ПутьКДанным);
	
	ТекстДляРедактирования = РВ_РедакторWysiwygHTMLКлиентСервер.ТекстКомментария(Форма, ПутьКДанным);
	
	ДанныеПрисоединенныхФайлов = РВ_РедакторWysiwygHTMLКлиентСервер.ДанныеПрисоединенныхФайлов(Форма, ПутьКДаннымБезЛишнего);
	
	РВ_РедакторWysiwygHTMLКлиентСервер.СконвертироватьИменаПрисоединенныхФайловВТексте(ДанныеПрисоединенныхФайлов,
	ТекстДляРедактирования);
	
	ЭлементПросмотраКомментария=Форма.Элементы[РВ_РедакторWysiwygHTMLКлиентСервер.ПолучитьИмяЭлементаРедактированияКомментария(ПутьКДанным)];
	
	
	Документ=ЭлементПросмотраКомментария.Документ.defaultView;
	Документ.appTo1C.setBaseURL(ПолучитьНавигационнуюСсылкуИнформационнойБазы()+"/ru");
	Документ.appTo1C.setHtmlText(ТекстДляРедактирования);

КонецПроцедуры

Процедура ДобавитьНовыйПрисоединенныйФайл(ИмяФайла, ПутьКФайлу, Форма, ПутьКДаннымБезЛишнего,ЭтоКартинка=Ложь, Адрес = Неопределено) 

	Если Адрес = Неопределено Тогда
		Адрес = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПутьКФайлу), Форма.УникальныйИдентификатор);
	КонецЕсли;

	ИмяТаблицыФайлов=РВ_РедакторWysiwygHTMLКлиентСервер.ИмяТаблицыПрисоединенныхФайлов(ПутьКДаннымБезЛишнего);

	СтрокаПрисоединенногоФайла = Форма[ИмяТаблицыФайлов].Добавить();
	СтрокаПрисоединенногоФайла.ПутьКФайлу = ПутьКФайлу;
	СтрокаПрисоединенногоФайла.ИмяФайла = ИмяФайла;
	СтрокаПрисоединенногоФайла.Адрес = Адрес;
	СтрокаПрисоединенногоФайла.ЭтоНовый = Истина;

	Форма.РВ_РедакторWysiwyg_Подключаемый_ПриДобавленииПрисоединенногоФайла(ИмяФайла, СтрокаПрисоединенногоФайла.ПолучитьИдентификатор(),
	ПутьКДаннымБезЛишнего);
	
	Если ЭтоКартинка Тогда
		ВставитьКартинкуВПолеРедактораКомментария(Форма, СтрокаПрисоединенногоФайла.Адрес,ПутьКДаннымБезЛишнего,СтрокаПрисоединенногоФайла.ИмяФайла);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедуры


Процедура ДобавитьИзФайловойСистемыБезРасширенияПослеЗагрузкиФайла(Помещен, Адрес, ВыбранноеИмяФайла,
	ПараметрыВыполнения) Экспорт

	Если Не Помещен Тогда
		Возврат;
	КонецЕсли;

	СтруктураПути = РВ_РедакторWysiwygHTMLКлиентСервер.РазложитьПолноеИмяФайла(ВыбранноеИмяФайла);
	ДобавитьНовыйПрисоединенныйФайл(СтруктураПути.Имя, ВыбранноеИмяФайла, ПараметрыВыполнения.ФормаВладелец,
		ПараметрыВыполнения.ПутьКДаннымБезЛишнего, Ложь, Адрес);

КонецПроцедуры

Процедура КомандаВставитьИзображениеИзБуфераОбменаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) <> Тип("ДвоичныеДанные") Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКДаннымБезЛишнего=ДополнительныеПараметры.ПутьКДаннымБезЛишнего;
	
	Адрес = ПоместитьВоВременноеХранилище(Результат,ДополнительныеПараметры.Форма.УникальныйИдентификатор);
	#Если Не ВебКлиент Тогда
		ПутьКФайлу=ПолучитьИмяВременногоФайла("png");
		Результат.Записать(ПутьКФайлу);
		ИмяФайла = РВ_РедакторWysiwygHTMLКлиентСервер.РазложитьПолноеИмяФайла(ПутьКФайлу).Имя;
		
	#Иначе
		ПутьКФайлу = "";
		ИмяФайла = Формат(ТекущаяУниверсальнаяДатаВМиллисекундах(),"ЧГ=0")+".png";
		
	#КонецЕсли
	
	ИмяТаблицыФайлов=РВ_РедакторWysiwygHTMLКлиентСервер.ИмяТаблицыПрисоединенныхФайлов(ПутьКДаннымБезЛишнего);
	Если ДополнительныеПараметры.Форма[ИмяТаблицыФайлов].НайтиСтроки(
		Новый Структура("ИмяФайла", ИмяФайла)).Количество() = 0 Тогда
		
		//ВставитьКартинкуВПолеРедактораКомментария(ДополнительныеПараметры.Форма, 
		ДобавитьНовыйПрисоединенныйФайл(ИмяФайла, ПутьКФайлу, ДополнительныеПараметры.Форма, ПутьКДаннымБезЛишнего,Истина,Адрес);
	Иначе
		Сообщить("Файл с таким именем уже добавлен");
	КонецЕсли;
	//ВыполнитьЗаменуВТекстеКомментарияПоСтруктуреЗамены(ДополнительныеПараметры.Форма,ДополнительныеПараметры.Команда.Имя,СтруктураСтрокMD);
КонецПроцедуры

Процедура ВставитьКартинкуВПолеРедактораКомментария(Форма, Адрес, ПутьКДаннымБезЛишнего, ИмяФайла) Экспорт
	ИмяЭлемента=РВ_РедакторWysiwygHTMLКлиентСервер.ПолучитьИмяЭлементаРедактированияКомментария(ПутьКДаннымБезЛишнего);
	
	Элемент=Форма.Элементы[ИмяЭлемента];
	
	Элемент.Документ.defaultView.appTo1C.insertImage(Адрес,ИмяФайла);
КонецПроцедуры

#КонецОбласти
Процедура СформироватьНаименование() Экспорт 
	Наименование=""+ВидПодключения +" "+АдресПодключения+?(ЗначениеЗаполнено(ПредварительноеПодключение)," через "+ПредварительноеПодключение,"");
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	СформироватьНаименование();
	
КонецПроцедуры

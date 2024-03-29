
Процедура ОтборВСписке(СписокДляОтбора, ИмяПоляДляОтбора, ЗначениеДляОтбора) Экспорт
	
	ПолеДляОтбора = Новый ПолеКомпоновкиДанных(ИмяПоляДляОтбора);	
	
	НайденныйОтбор = Неопределено;
	
	Для Каждого ЭлементОтбора Из СписокДляОтбора.Отбор.Элементы Цикл
		
		Если ЭлементОтбора.ЛевоеЗначение = ПолеДляОтбора Тогда
			
			НайденныйОтбор = ЭлементОтбора;
			
		КонецЕсли;                         
		
	КонецЦикла;
	
	Если НайденныйОтбор = Неопределено Тогда
		
		НайденныйОтбор = СписокДляОтбора.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НайденныйОтбор.ЛевоеЗначение = ПолеДляОтбора;
		
	КонецЕсли;
	
	НайденныйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	НайденныйОтбор.ПравоеЗначение = ЗначениеДляОтбора;
	НайденныйОтбор.Использование = Истина;
	
КонецПроцедуры           



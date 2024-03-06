
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ТипКлиента = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
	Ответственный = ПараметрыСеанса.ТекущийСотрудник;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)        
	
	ТипКлиентаЮрЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
	ТипКлиентаФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;        

	ДлинаИНН = СтрДлина(ИНН);
	ДлинаКПП = СтрДлина(КПП);   
	
	ЧисловойРяд = "0123456789";
                            
	Если ТипКлиента = ТипКлиентаЮрЛицо И ДлинаИНН <> 10 И ДлинаИНН <> 0 Тогда
		Сообщить("Длина ИНН должна быть 10 символов!");
		Отказ = Истина;
  	ИначеЕсли ТипКлиента = ТипКлиентаЮрЛицо И ДлинаКПП < 9 Тогда
		Сообщить("Длина КПП должна быть 9 символов!");
		Отказ = Истина;
	ИначеЕсли ТипКлиента = ТипКлиентаФизЛицо И ДлинаИНН <> 12 И ДлинаИНН <> 0 Тогда
		Сообщить("Длина ИНН должна быть 12 символов!");
		Отказ = Истина;
	ИначеЕсли ТипКлиента = ТипКлиентаФизЛицо И ДлинаКПП > 0 Тогда
		Сообщить("КПП заполнять не нужно!");
		Отказ = Истина;
	КонецЕсли;
	
	// Проверка на наличие НЕ цифр в ИНН
	Для Счетчик = 1 По ДлинаИНН Цикл
		
		  СимволСтроки = Сред(ИНН, Счетчик, 1);
		  Если СтрНайти(ЧисловойРяд, СимволСтроки) = 0 Тогда
			  Сообщить("В ИНН должны быть только цифры! Найден лишний символ: " + СимволСтроки);
			  Отказ = Истина;
			  Прервать;
		  КонецЕсли;
		
	КонецЦикла;
	  
	// Проверка на наличие НЕ цифр в КПП
	Для Счетчик = 1 По ДлинаКПП Цикл
		
		  СимволСтроки = Сред(КПП, Счетчик, 1);
		  Если СтрНайти(ЧисловойРяд, СимволСтроки) = 0 Тогда
			  Сообщить("В КПП должны быть только цифры! Найден лишний символ: " + СимволСтроки);
			  Отказ = Истина;
			  Прервать;
		  КонецЕсли;
		
	  КонецЦикла;  
	  
	    // Проверка на корректность ИНН
		Если РаботаСИНН.ИННВерен(ИНН) = Ложь Тогда
		     Сообщить("Контрольная сумма ИНН не совпадает, проверьте правильность ввода");
		КонецЕсли;  
		Если ЗначениеЗаполнено(РаботаСИНН.ПроверкаИННСВыводом(ИНН)) Тогда
		     Сообщить(РаботаСИНН.ПроверкаИННСВыводом(ИНН));
		КонецЕсли; 
		

КонецПроцедуры



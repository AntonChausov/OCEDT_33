
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Отбор") Тогда
		Если Параметры.Отбор.Свойство("Уволен") Тогда
			Если Параметры.Отбор.Уволен Тогда
				ЭтотОбъект.Заголовок = "Уволенные сотрудники";
			Иначе
				ЭтотОбъект.Заголовок = "Работающие сотрудники";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

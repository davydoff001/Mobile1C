
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Имя = ПолучитьИмяВременногоФайла("html");
	Шаблон = Обработки.СделатьПодпись.ПолучитьМакет("ШаблонДокумента");
	
	
	ТХТ = Новый ЗаписьТекста(Имя, "UTF-8");
	ТХТ.Записать(Шаблон.Область(1,1).Текст);
	ТХТ.Закрыть();
	ДокументHTML = Имя;
КонецПроцедуры

&НаКлиенте
Процедура ДокументHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	ДДКартины = СтрЗаменить(ДанныеСобытия.document.getElementById("signel").href,"data:image/png;base64,","");	
	ДД = Base64Значение(ДДКартины);
	Результат = ПоместитьВоВременноеХранилище(ДД);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	//TODO: Вставить содержимое обработчика
КонецПроцедуры


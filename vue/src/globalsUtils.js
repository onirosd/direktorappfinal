import moment from 'moment';
import 'moment-timezone';



Date.prototype.sumar_restar_Fecha = function(dias) {


  // Crear un objeto moment a partir de la fecha actual

  // let fechaMoment = moment(fecha);
  const fechaMoment = moment.tz(this, 'America/Lima');

  // fechaMoment.locale('es');

  // Sumar o restar los días especificados
  fechaMoment.add(dias, 'days');

  // Devolver el resultado como una nueva fecha
  return fechaMoment.format('YYYY-MM-DD');
};



// Date.prototype.getDayAdjusted = function() {
//   let day = this.getDay();
//   return (day + 6) % 7;  // 0: Lunes, 1: Martes, ..., 6: Domingo
// };

Date.prototype.getDayCorta= function(day_data) {
  // Convertir el objeto Date a un objeto moment
  // const fechaMoment = moment(this);
  const fechaMoment = moment(day_data, 'YYYYMMDD');

  // Sumar la cantidad especificada de días y formatear la fecha al formato deseado
  // return fechaMoment.add(daysToAdd, 'days').format('YYYY-MM-DD');

return fechaMoment.locale('es').format('MMMDD/YY');
};


Date.prototype.getDayAdjusted = function() {
  // Convertir el objeto Date a un objeto moment
  const fechaMoment = moment(this);

  // Establecer el primer día de la semana como lunes
  fechaMoment.locale('es');  // En la mayoría de las configuraciones locales en español, el lunes se considera el primer día de la semana

  // Obtener el día de la semana (0: Lunes, 1: Martes, ..., 6: Domingo)
  let day = fechaMoment.isoWeekday() - 1;

  return day;
};

// Extender el prototipo de Date para ajustar el día de la semana con una fecha opcional
Date.prototype.getDayAdjustedforDate = function(dateString) {
  let fechaMoment;

  // Si se proporciona dateString, analizar esa fecha
  if (dateString) {
    fechaMoment = moment(dateString, 'YYYYMMDD');
  } else {
    // De lo contrario, usar el objeto Date actual
    fechaMoment = moment(this);
  }

  // Establecer el primer día de la semana como lunes
  fechaMoment.locale('es'); // En la mayoría de las configuraciones locales en español, el lunes se considera el primer día de la semana

  // Obtener el día de la semana (0: Lunes, 1: Martes, ..., 6: Domingo)
  let day = fechaMoment.isoWeekday() - 1;

  return day;
};

Date.prototype.addDays = function(daysToAdd = 1) {
  // Convertir el objeto Date a un objeto moment
  const fechaMoment = moment(this);

  // Sumar la cantidad especificada de días y formatear la fecha al formato deseado
  return fechaMoment.add(daysToAdd, 'days').format('YYYY-MM-DD');
};


Date.prototype.getFormattedDateType1 = function() {
  const year = this.getFullYear();
  const month = String(this.getMonth() + 1).padStart(2, '0');  // Los meses son 0-indexados
  const day = String(this.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

Date.prototype.getModifiedWeekMonthYearFormat = function(timezone = 'America/Lima') {
  const momentDate = moment.tz(this, timezone);

  // Determinar el número de semana de la fecha dada
  let weekOfYear = momentDate.week();

  // Obtener el primer día de la semana
  let startOfWeek = momentDate.clone().startOf('week');

  let month;
  // Si el primer día de la semana es del mes anterior, entonces la fecha pertenece al mes anterior
  if (startOfWeek.month() !== momentDate.month()) {
    month = String(startOfWeek.month() + 1).padStart(2, '0');
  } else {
    month = String(momentDate.month() + 1).padStart(2, '0');
  }

  const year = momentDate.year();
  return `${weekOfYear}${month}${year}`;
};


Date.prototype.getModifiedWeekYearFormat = function(timezone = 'America/Lima') {
  const momentDate = moment.tz(this, timezone);

  // Determinar el número de semana de la fecha dada
  let weekOfYear = momentDate.week();

  // Obtener el primer día de la semana
  let startOfWeek = momentDate.clone().startOf('week');

  let month;
  // Si el primer día de la semana es del mes anterior, entonces la fecha pertenece al mes anterior
  if (startOfWeek.month() !== momentDate.month()) {
    month = String(startOfWeek.month() + 1).padStart(2, '0');
  } else {
    month = String(momentDate.month() + 1).padStart(2, '0');
  }

  const year = momentDate.year();
  return `${weekOfYear}${year}`;
};





Date.prototype.getUniqueWeekNumber = function(timezone = 'America/Lima') {
  const momentDate = moment.tz(this, timezone);
  const startOfYear = moment.tz({year: momentDate.year(), month: 0, day: 1}, timezone);

  // Calcular el número de días desde el comienzo del año
  const daysPassed = momentDate.diff(startOfYear, 'days');

  // Determinar qué día de la semana es el 1 de enero
  const startDay = startOfYear.day();

  // Calcula el número de semana
  let weekNumber = Math.ceil((daysPassed + startDay) / 7);

  return weekNumber;
};


Date.prototype.getWeek = function(timezone = 'America/Lima') {
    return moment.tz(this, timezone).week();
};

Date.prototype.toWeekFormat = function(timezone = 'America/Lima') {
    const weekNumber = this.getWeek(timezone);
    const year = this.getFullYear().toString(); // Obtén solo los dos últimos dígitos del año.
    return `${weekNumber}${year}`;
};

Date.prototype.getYearAndMonth = function(timezone = 'America/Lima') {
    const m = moment.tz(this, timezone);
    const year = m.year();
    const month = m.format('MMM'); // Obtiene el mes abreviado.
    return `${year} ${month}`;
};

Date.prototype.getYearAndMonthNumber = function(timezone = 'America/Lima') {
    const m = moment.tz(this, timezone);
    const year = m.year();
    const month = m.month() + 1; // Los meses en Moment.js también van de 0 a 11.
    return `${year}${month.toString().padStart(2, '0')}`; // Aseguramos que el mes tenga dos dígitos.
};

String.prototype.convertToYearAndMonth = function() {
    const year = this.slice(0, 4);
    const month = parseInt(this.slice(4, 6)) - 1; // Restamos 1 porque los meses en Moment.js van de 0 a 11.
    const date = new Date(year, month);
    const m = moment(date);
    const monthName = m.format('MMM'); // Obtiene el mes abreviado.
    return `${year} ${monthName}`;
};




// Date.prototype.getWeek = function(timezone = 'America/Lima') {
//   var onejan = new Date(this.getFullYear(), 0, 1);
//   return Math.ceil((((this - onejan) / 86400000) + onejan.getDay() + 1) / 7);
// };


// Date.prototype.toWeekFormat = function() {
//   const weekNumber = this.getWeek();
//   const year = this.getFullYear().toString(); // Obtén solo los dos últimos dígitos del año.
//   return `${weekNumber}${year}`;
// };


// Date.prototype.getYearAndMonth = function() {
//   const year = this.getFullYear();
//   const month = this.toLocaleString('default', { month: 'short' }); // 'short' para abreviaturas como "Nov", 'long' para "November"
//   return `${year} ${month}`;
// };



// Date.prototype.getYearAndMonthNumber = function() {
//   const year = this.getFullYear();
//   const month = this.getMonth() + 1; // Los meses en JavaScript van de 0 a 11, por eso sumamos 1
//   return `${year}${month.toString().padStart(2, '0')}`; // Aseguramos que el mes tenga dos dígitos
// };

// String.prototype.convertToYearAndMonth = function() {
//   const year = this.slice(0, 4);
//   const month = parseInt(this.slice(4, 6)) - 1; // Restamos 1 porque los meses en JavaScript van de 0 a 11
//   const date = new Date(year, month);
//   const monthName = date.toLocaleString('default', { month: 'short' }); // 'short' para abreviaturas como "Nov", 'long' para "November"
//   return `${year} ${monthName}`;
// };

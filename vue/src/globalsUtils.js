import moment from 'moment';
import 'moment-timezone';





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

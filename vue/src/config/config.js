// src/config/config.js
import moment from 'moment';
import 'moment/locale/es';
import momentTimezone from 'moment-timezone';
import 'moment-timezone/data/packed/latest.json'; // Asegúrate de cargar la base de datos más reciente

// Configurar Moment.js para la zona horaria de Lima/Perú y el inicio de semana en lunes
moment.tz.setDefault('America/Lima');
moment.updateLocale('es', {
    week: {
      dow: 1, // Establecer lunes como el primer día de la semana
      doy: 7
    }
});

export default moment;

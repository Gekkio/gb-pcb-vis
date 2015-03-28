var _ = {
  forEach: require('lodash.foreach'),
  range: require('lodash.range'),
  uniqueId: require('lodash.uniqueid')
};
var riot = require('riot');

require('./gb-pcb-vis.tag');

var connections = {};

connections.cartridge =
  ['VCC', 'CLK', 'WR', 'RD', 'MREQ'].concat(
    // A0 - A15
    _.range(16).map(function(n) { return 'A' + n; }),
    // D0 - D7
    _.range(8).map(function(n) { return 'D' + n; }),
    ['RS', 'VIN', 'GND']
  );

connections.mbc1 = connections.cartridge.concat(
  ['M14', 'M15', 'M16', 'M17', 'M18']
);

var Connection = function(id, name) {
  this.id = id;
  this.name = name;
  this.selected = false;
  this.hovering = false;
  riot.observable(this);
};

Connection.prototype.setSelected = function(value) {
  if (this.selected != value) {
    this.selected = value;
    this.trigger('selected', value);
  }
};

Connection.prototype.setHovering = function(value) {
  if (this.hovering != value) {
    this.hovering = value;
    this.trigger('hovering', value);
  }
};

function makeConnections(names) {
  var result = {};
  _.forEach(names, function(name) {
    var id = 'pcb-' + name.toLowerCase();
    result[id] = new Connection(id, name);
  });
  return result;
}

function mount(selector, config) {
  riot.mount(selector, {
    connections: makeConnections(config.connections),
    images: config.images,
    prefix: _.uniqueId('gbpcbvis-')
  });
}

module.exports = {
  connections: connections,
  mount: mount
};

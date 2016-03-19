<gbpcbvis-svg>
  <script>
    var _ = {
      forEach: require('lodash.foreach'),
    };
    var request = require('superagent');

    function setBooleanAttribute(el, attrName, value) {
      if (value) {
        el.setAttribute(attrName, '');
      } else {
        el.removeAttribute(attrName);
      }
    }

    this.connections = opts.connections;
    this.on('mount', function() {
      var self = this;
      var root = this.root;
      request
        .get(opts.svg)
        .end(function(err, res) {
          root.innerHTML = res.text;
          _.forEach(root.querySelectorAll('#pcb-connections > g'), function(el) {
            var connection = self.connections[el.id];
            if (connection) {
              connection.on('selected', function(value) {
                setBooleanAttribute(el, 'data-selected', value);
              });
              connection.on('hovering', function(value) {
                setBooleanAttribute(el, 'data-hovering', value);
              });
            }
          });
        });
    });
  </script>
</gbpcbvis-svg>

<gbpcbvis>
  <div if={ loaded } class="controls">
    <div class="size" onchange={ onSizeChange }>
      <input id={ this.prefix + '-small' } type="radio" name={ this.prefix + '-size' } value="small" checked={ size === 'small' }>
      <label for={ this.prefix + '-small' }>Small</label><br>
      <input id={ this.prefix + '-large' } type="radio" name={ this.prefix + '-size' } value="large" checked={ size === 'large' }>
      <label for={ this.prefix + '-large' }>Large</label><br>
    </div>
    <ul class="connections"><li
        each={ connectionValues }
        class={ selected: selected, hovering: hovering }
        onmouseover={ parent.onConnectionMouseover }
        onmouseout={ parent.onConnectionMouseout }
        onclick={ parent.onConnectionClick }>{ name }</li></ul>
  </div>

  <div if={ loaded } class="images"><div data-is="gbpcbvis-svg"
      each={ svgs }
      svg={ svg }
      class={ "gbpcbvis-svg " + parent.size }
      connections={ parent.connections }
      onclick={ parent.onSvgClick }
      onmouseover={ parent.onSvgMouseover }
      onmouseout={ parent.onSvgMouseout }></div></div>

  <div if={ !loaded } class="placeholders">
    <a each={ images } href={ href }>
      <img width="400" src={ thumb }>
    </a>
  </div>
  <button if={ !loaded } onclick={ load }>Load interactive PCB visualization</button>

  <script>
    var _ = {
      forEach: require('lodash.foreach'),
      values: require('lodash.values')
    };

    this.prefix = opts.prefix;
    this.loaded = false;
    this.images = opts.images;
    this.svgs = [];
    this.size = 'small';
    this.connections = opts.connections;
    this.connectionValues = _.values(this.connections);

    load(e) {
      if (!this.loaded) {
        this.loaded = true;
        var svgs = this.svgs;
        _.forEach(this.images, function(image) {
          svgs.push(image);
        });
      }
    }
    onSizeChange(e) {
      this.size = e.target.value;
    }
    onConnectionClick(e) {
      e.item.setSelected(!e.item.selected);
    }
    onConnectionMouseover(e) {
      e.item.setHovering(true);
    }
    onConnectionMouseout(e) {
      e.item.setHovering(false);
    }
    lookupConnection(el) {
      var id;
      while (el && el.id !== 'pcb-connections') {
        if (el.id) {
          id = el.id;
        }
        el = el.parentElement;
      }      
      return this.connections[id];
    }
    onSvgClick(e) {
      var connection = this.lookupConnection(e.target);
      if (connection) {
        connection.setSelected(!connection.selected);
      }
    }
    onSvgMouseover(e) {
      var connection = this.lookupConnection(e.target);
      if (connection) {
        connection.setHovering(true);
      }
    }
    onSvgMouseout(e) {
      var connection = this.lookupConnection(e.target);
      if (connection) {
        connection.setHovering(false);
      }
    }
  </script>
</gbpcbvis>

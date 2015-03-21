module.exports = function(Handlebars) {

this["JST"] = this["JST"] || {};

this["JST"]["home.info"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "here is some information";
  },"useData":true});

this["JST"]["selectdna.alphatree"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  var helper, functionType="function", helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;
  return "  <div class=\"panel panel-default\">\n    <div class=\"panel-heading\" role=\"tab\" id=\"heading"
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\">\n      <h4 class=\"panel-title\">\n        <a data-toggle=\"collapse\" data-parent=\"#accordion\" href=\"#collapse"
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\" aria-expanded=\"true\" aria-controls=\"collapse"
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\">\n	        "
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\n        </a>\n      </h4>\n    </div>\n    <div id=\"collapse"
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\" class=\"panel-collapse collapse\" role=\"tabpanel\" aria-labelledby=\"heading"
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\">\n    	"
    + escapeExpression(((helper = (helper = helpers.folders || (depth0 != null ? depth0.folders : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"folders","hash":{},"data":data}) : helper)))
    + "\n    </div>\n  </div>";
},"useData":true});

this["JST"]["selectdna.content"] = Handlebars.template({"1":function(depth0,helpers,partials,data) {
  var stack1, helper, functionType="function", helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, buffer = "\n		<div class=\"panel panel-default\">\n			<div class=\"panel-heading\" role=\"tab\" id=\"heading"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\">\n				<h4 class=\"panel-title\">\n					<a data-toggle=\"collapse\" data-parent=\"#accordion\" href=\"#selectdna-"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\" aria-expanded=\"true\" aria-controls=\"selectdna-"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\">\n						"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\n					</a>\n				</h4>\n			</div>\n			<div id=\"selectdna-"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\" class=\"panel-collapse collapse\" role=\"tabpanel\" aria-labelledby=\"heading"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\">\n				<ul class=\"list-group\">\n";
  stack1 = helpers.each.call(depth0, (depth0 != null ? depth0.folders : depth0), {"name":"each","hash":{},"fn":this.program(2, data),"inverse":this.noop,"data":data});
  if (stack1 != null) { buffer += stack1; }
  return buffer + "				</ul>\n			</div>\n		</div>\n\n";
},"2":function(depth0,helpers,partials,data) {
  var stack1, helper, functionType="function", helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, buffer = "						<li class=\"list-group-item\" id='folder-"
    + escapeExpression(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"id","hash":{},"data":data}) : helper)))
    + "'>\n							<div class=\"row genome-model-container\">\n								<div class=\"text\">\n									";
  stack1 = ((helper = (helper = helpers.foldername || (depth0 != null ? depth0.foldername : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"foldername","hash":{},"data":data}) : helper));
  if (stack1 != null) { buffer += stack1; }
  buffer += " - <span class='download'>";
  stack1 = ((helper = (helper = helpers.downloaded || (depth0 != null ? depth0.downloaded : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"downloaded","hash":{},"data":data}) : helper));
  if (stack1 != null) { buffer += stack1; }
  return buffer + "</span>\n								</div>\n								<div class=\"loading\">\n\n								</div>\n							</div>\n						</li>\n";
},"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  var stack1, buffer = "\n<ol class=\"breadcrumb\">\n	<li class=\"active\">\n		<i class=\"fa fa-location-arrow\"></i> Currently Selected DNA: <b id='selected-dna'>...</b>\n	</li>\n</ol>\n<div class=\"panel-group\" id=\"accordion\" role=\"tablist\" aria-multiselectable=\"true\">\n\n\n";
  stack1 = helpers.each.call(depth0, (depth0 != null ? depth0.alphatree : depth0), {"name":"each","hash":{},"fn":this.program(1, data),"inverse":this.noop,"data":data});
  if (stack1 != null) { buffer += stack1; }
  return buffer + "\n\n</div>\n\n";
},"useData":true});

this["JST"]["selectdna.download"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  var helper, functionType="function", helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;
  return "<button type='button' class='btn btn-link download-genome-link' data-href='/selectdna/download/"
    + escapeExpression(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"id","hash":{},"data":data}) : helper)))
    + "'>Download</button>\n";
},"useData":true});

this["JST"]["selectdna.downloading"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "<div class=\"progress\">\n  <div class=\"progress-bar progress-bar-striped active\" role=\"progressbar\" aria-valuenow=\"100\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 100%\">\n    <span class=\"\">Loading...</span>\n  </div>\n</div>";
  },"useData":true});

this["JST"]["selectdna.select"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  var helper, functionType="function", helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;
  return "<button type='button' class='btn btn-link select-genome-link' data-href='/selectdna/select/"
    + escapeExpression(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"id","hash":{},"data":data}) : helper)))
    + "'>Select</button>\n";
},"useData":true});

this["JST"]["skewanalyze.layout"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "\n<ol class=\"breadcrumb\">\n	<li class=\"active\">\n		<i class=\"fa fa-location-arrow\"></i> Currently Selected DNA: <b id='selected-dna'>...</b>\n	</li>\n</ol>\n\n<div class='row'>\n	<div class='col-md-4'>\n\n		<form>\n			<table class=\"table\">\n				<tbody>\n					<tr>\n						<th>Name</th>\n						<td id='dna-name'>...</td>\n					</tr>\n					<tr>\n						<th>Accession</th>\n						<td id='dna-fna'>...</td>\n					</tr>\n					<tr>\n						<th>Bp length</th>\n						<td><span id='dna-length'></span></td>\n					</tr>\n				</tbody>\n			</table>\n			<div class='form-group'>\n				<label>Window size: <span id='window-size-label'>10000</span>bp</label>\n				<input type='range' min='1000' max='1000000' step=\"1000\" value=\"500000\" id='window-size'>\n			</div>\n			<div class='form-group'>\n				<label>\n\n					<table class='fraction'>\n						<tr>\n							<td nowrap=\"nowrap\">dy</td>\n						</tr>\n						<tr>\n							<td class='bottom'>dx</td>\n						</tr>\n					</table>\n\n					Sample frequency: every <span id='inclanation-freq-label'>100th</span>\n				</label>\n				<input type='range' min='1' max='500' step=\"1\" value=\"100\" id='inclanation-freq'>\n			</div>\n			<div class='form-group'>\n				<label>\n\n					<table class='fraction'>\n						<tr>\n							<td nowrap=\"nowrap\">dy</td>\n						</tr>\n						<tr>\n							<td class='bottom'>dx</td>\n						</tr>\n					</table>\n\n					Diff threshold: <span id='threshold-label'></span></label>\n				<input type='range' min='0.01' max='0.2' step=\"0.01\" value=\"0.1\" id='threshold'>\n			</div>\n			<div class='form-group'>\n				<label>Speed cap: <span id='speed-cap-label'>uncapped</span></label>\n				<input type='range' min='10' max='65' step=\"5\" value=\"65\" id='speed-cap'>\n			</div>\n			<div class=\"form-group\">\n				<p>\n					<button type=\"button\" class=\"btn btn-primary btn-lg\" id=\"start-analyze\">Run</button>\n					<button type=\"button\" class=\"btn btn-danger btn-lg\" id=\"stop-analyze\" disabled=\"disabled\">Stop</button>\n					<button type=\"button\" class=\"btn btn-link btn-lg\" disabled=\"disabled\" id=\"skew-progress\"></button>\n				</p>\n			</div>	\n		</form>\n\n\n	</div>\n	<div class='col-md-4'>\n		<div id='synthesized-dna-graph-buffer' width='320' height='240' style='width: 320px; height: 240px;'></div>\n	</div>\n	<div class='col-md-4'>\n		<div id='graph-placeholder' width='320' height='240' style='width: 320px; height: 240px;'></div>\n	</div>\n</div>\n";
  },"useData":true});

return this["JST"];

};
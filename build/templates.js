module.exports = function(Handlebars) {

this["JST"] = this["JST"] || {};

this["JST"]["dnaa.content"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "<ol class=\"breadcrumb\">\r\n	<li class=\"active\">\r\n		<i class=\"fa fa-location-arrow\"></i> Currently Selected DNA: <b id='selected-dna'>...</b>\r\n	</li>\r\n</ol>\r\n\r\n<div class='row'>\r\n	<div class='col-md-4'>\r\n\r\n		<h3>Loading: <p class='percentage'></p></h3>\r\n		<pre class='output'></pre>\r\n\r\n	</div>\r\n	<div class='col-md-4' style='text-align: center;'>\r\n		<div id='synthesized-dna-graph-buffer' width='320' height='240' style='width: 320px; height: 240px; margin: auto;'></div>\r\n	</div>\r\n	<div class='col-md-4'>\r\n		<table class=\"table\" id='sequrence-table'>\r\n			<thead>\r\n				<tr>\r\n					<th>Sequence</th>\r\n					<th>BP index</th>\r\n					<th>Reverse complement</th>\r\n				</tr>\r\n			</thead>\r\n			<tbody>\r\n				<tr>\r\n					<td>ATCTCGA</td>\r\n					<td>1203401</td>\r\n					<td>TCGAGAT</td>\r\n				</tr>\r\n			</tbody>\r\n		</table>\r\n	</div>\r\n</div>\r\n\r\n";
  },"useData":true});

this["JST"]["gc.layout"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "\r\n<ol class=\"breadcrumb\">\r\n	<li class=\"active\">\r\n		<i class=\"fa fa-location-arrow\"></i> Currently Selected DNA: <b id='selected-dna'>...</b>\r\n	</li>\r\n</ol>\r\n\r\n<div class='row'>\r\n	<div class='col-md-4'>\r\n\r\n		<form>\r\n			<table class=\"table\">\r\n				<tbody>\r\n					<tr>\r\n						<th>Name</th>\r\n						<td id='dna-name'>...</td>\r\n					</tr>\r\n					<tr>\r\n						<th>Accession</th>\r\n						<td id='dna-fna'>...</td>\r\n					</tr>\r\n					<tr>\r\n						<th>Bp length</th>\r\n						<td><span id='dna-length'></span></td>\r\n					</tr>\r\n				</tbody>\r\n			</table>\r\n			<div class='form-group'>\r\n				<label>Window size: <span id='window-size-label'>10000</span>bp</label>\r\n				<input type='range' min='1000' max='1000000' step=\"1000\" value=\"500000\" id='window-size'>\r\n			</div>\r\n			<div class='form-group'>\r\n				<label>\r\n\r\n					<table class='fraction'>\r\n						<tr>\r\n							<td nowrap=\"nowrap\">dy</td>\r\n						</tr>\r\n						<tr>\r\n							<td class='bottom'>dx</td>\r\n						</tr>\r\n					</table>\r\n\r\n					Sample frequency: every <span id='inclanation-freq-label'>100th</span>\r\n				</label>\r\n				<input type='range' min='1' max='500' step=\"1\" value=\"100\" id='inclanation-freq'>\r\n			</div>\r\n			<div class='form-group'>\r\n				<label>\r\n\r\n					<table class='fraction'>\r\n						<tr>\r\n							<td nowrap=\"nowrap\">dy</td>\r\n						</tr>\r\n						<tr>\r\n							<td class='bottom'>dx</td>\r\n						</tr>\r\n					</table>\r\n\r\n					Diff threshold: <span id='threshold-label'></span></label>\r\n				<input type='range' min='0.005' max='0.15' step=\"0.001\" value=\"0.03\" id='threshold'>\r\n			</div>\r\n			<div class='form-group'>\r\n				<label>Speed cap: <span id='speed-cap-label'>uncapped</span></label>\r\n				<input type='range' min='10' max='65' step=\"5\" value=\"65\" id='speed-cap'>\r\n			</div>\r\n			<div class=\"form-group\">\r\n				<p>\r\n					<button type=\"button\" class=\"btn btn-primary btn-lg\" id=\"start-analyze\">Run</button>\r\n					<button type=\"button\" class=\"btn btn-danger btn-lg\" id=\"stop-analyze\" disabled=\"disabled\">Stop</button>\r\n					<button type=\"button\" class=\"btn btn-link btn-lg\" disabled=\"disabled\" id=\"skew-progress\"></button>\r\n				</p>\r\n			</div>	\r\n		</form>\r\n\r\n\r\n	</div>\r\n	<div class='col-md-4'>\r\n		<div id='synthesized-dna-graph-buffer' width='320' height='240' style='width: 320px; height: 240px;'></div>\r\n	</div>\r\n	<div class='col-md-4'>\r\n		<div id='graph-placeholder' width='320' height='240' style='width: 320px; height: 240px;'></div>\r\n	</div>\r\n</div>\r\n";
  },"useData":true});

this["JST"]["home.info"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "The bioinformatics research is of importance to answer many biological questions. The\r\nquestion of where the area that results in replication initiation (OriC) is localized is of great\r\nsignificance for future progress in many biological fields including research on viral vectors,\r\ngene therapy and cancer. There is currently a lack of interdisciplinary knowledge in\r\nbioinformatics, despite all the knowledge in biology and computer science. Thus to join the\r\ntwo fields into the interdisciplinary science of bioinformatics, this project is investigating: <em>How\r\ncan an open source program be built with the functionality of finding the origin of replication\r\n(OriC) in sequenced bacterial genomes utilizing fast algorithmic methods?</em> The used method\r\nconsisted of creating this application containing three main parts. The first part is managing the\r\ngenomes and the <a href=\"/OriC-finder/select/\">integration with GenBank </a>. The second is built around a method of analysis called <a href=\"/OriC-finder/gc-skew/\">CGC­skew</a> which examines the ratio of the different nucleobases in DNA. Finally an <a href=\"/OriC-finder/dnaa/\">algorithm</a> finding the most common sequences of a certain length in DNA was made using\r\nalternative data structures to optimize the runtime of the analysis. The application was developed open source\r\nto open up the posibility for other people to be involved in the development of the code.\r\n";
  },"useData":true});

this["JST"]["select.alphatree"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  var helper, functionType="function", helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;
  return "  <div class=\"panel panel-default\">\r\n    <div class=\"panel-heading\" role=\"tab\" id=\"heading"
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\">\r\n      <h4 class=\"panel-title\">\r\n        <a data-toggle=\"collapse\" data-parent=\"#accordion\" href=\"#collapse"
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\" aria-expanded=\"true\" aria-controls=\"collapse"
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\">\r\n	        "
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\r\n        </a>\r\n      </h4>\r\n    </div>\r\n    <div id=\"collapse"
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\" class=\"panel-collapse collapse\" role=\"tabpanel\" aria-labelledby=\"heading"
    + escapeExpression(((helper = (helper = helpers.alphanumber || (depth0 != null ? depth0.alphanumber : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"alphanumber","hash":{},"data":data}) : helper)))
    + "\">\r\n    	"
    + escapeExpression(((helper = (helper = helpers.folders || (depth0 != null ? depth0.folders : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"folders","hash":{},"data":data}) : helper)))
    + "\r\n    </div>\r\n  </div>";
},"useData":true});

this["JST"]["select.content"] = Handlebars.template({"1":function(depth0,helpers,partials,data) {
  var stack1, helper, functionType="function", helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, buffer = "\r\n		<div class=\"panel panel-default\">\r\n			<div class=\"panel-heading\" role=\"tab\" id=\"heading"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\">\r\n				<h4 class=\"panel-title\">\r\n					<a data-toggle=\"collapse\" data-parent=\"#accordion\" href=\"#selectdna-"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\" aria-expanded=\"true\" aria-controls=\"selectdna-"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\">\r\n						"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\r\n					</a>\r\n				</h4>\r\n			</div>\r\n			<div id=\"selectdna-"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\" class=\"panel-collapse collapse\" role=\"tabpanel\" aria-labelledby=\"heading"
    + escapeExpression(((helper = (helper = helpers.letter || (depth0 != null ? depth0.letter : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"letter","hash":{},"data":data}) : helper)))
    + "\">\r\n				<ul class=\"list-group\">\r\n";
  stack1 = helpers.each.call(depth0, (depth0 != null ? depth0.folders : depth0), {"name":"each","hash":{},"fn":this.program(2, data),"inverse":this.noop,"data":data});
  if (stack1 != null) { buffer += stack1; }
  return buffer + "				</ul>\r\n			</div>\r\n		</div>\r\n\r\n";
},"2":function(depth0,helpers,partials,data) {
  var stack1, helper, functionType="function", helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, buffer = "						<li class=\"list-group-item\" id='folder-"
    + escapeExpression(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"id","hash":{},"data":data}) : helper)))
    + "'>\r\n							<div class=\"row genome-model-container\">\r\n								<div class=\"text\">\r\n									";
  stack1 = ((helper = (helper = helpers.foldername || (depth0 != null ? depth0.foldername : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"foldername","hash":{},"data":data}) : helper));
  if (stack1 != null) { buffer += stack1; }
  buffer += " - <span class='download'>";
  stack1 = ((helper = (helper = helpers.downloaded || (depth0 != null ? depth0.downloaded : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"downloaded","hash":{},"data":data}) : helper));
  if (stack1 != null) { buffer += stack1; }
  return buffer + "</span>\r\n								</div>\r\n								<div class=\"loading\">\r\n\r\n								</div>\r\n							</div>\r\n						</li>\r\n";
},"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  var stack1, buffer = "\r\n<ol class=\"breadcrumb\">\r\n	<li class=\"active\">\r\n		<i class=\"fa fa-location-arrow\"></i> Currently Selected DNA: <b id='selected-dna'>...</b>\r\n	</li>\r\n</ol>\r\n<div class=\"panel-group\" id=\"accordion\" role=\"tablist\" aria-multiselectable=\"true\">\r\n\r\n\r\n";
  stack1 = helpers.each.call(depth0, (depth0 != null ? depth0.alphatree : depth0), {"name":"each","hash":{},"fn":this.program(1, data),"inverse":this.noop,"data":data});
  if (stack1 != null) { buffer += stack1; }
  return buffer + "\r\n\r\n</div>\r\n\r\n";
},"useData":true});

this["JST"]["select.download"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  var helper, functionType="function", helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;
  return "<button type='button' class='btn btn-link download-genome-link' data-href='/selectdna/download/"
    + escapeExpression(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"id","hash":{},"data":data}) : helper)))
    + "'>Download</button>\r\n";
},"useData":true});

this["JST"]["select.downloading"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  return "<div class=\"progress\">\r\n  <div class=\"progress-bar progress-bar-striped active\" role=\"progressbar\" aria-valuenow=\"100\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 100%\">\r\n    <span class=\"\">Loading...</span>\r\n  </div>\r\n</div>";
  },"useData":true});

this["JST"]["select.select"] = Handlebars.template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  var helper, functionType="function", helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;
  return "<button type='button' class='btn btn-link select-genome-link' data-href='/selectdna/select/"
    + escapeExpression(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : helperMissing),(typeof helper === functionType ? helper.call(depth0, {"name":"id","hash":{},"data":data}) : helper)))
    + "'>Select</button>\r\n";
},"useData":true});

return this["JST"];

};
require "rails"
require "nokogiri"
require "rjb"
require "rjb-loader"
require "jasper-on-rails-pdf/version"
require "jasper-on-rails-pdf/pdf_generator"

module JasperOnRailsPdf
  class << self
    attr_accessor :config
  end

  self.config = {
    report_params: {},
    response_options: {},
    xml_options: {}
  }

  RjbLoader.before_load do |config|
    # This code changes the JVM classpath, so it has to run BEFORE loading Rjb.
    Dir["#{File.dirname(__FILE__)}/java/*.jar"].each do |path|
      config.classpath << File::PATH_SEPARATOR + File.expand_path(path)
    end
  end

  RjbLoader.after_load do
    JASPER_COMPILE_MANAGER          = Rjb::import 'net.sf.jasperreports.engine.JasperCompileManager'
    JASPER_EXPORT_MANAGER           = Rjb::import 'net.sf.jasperreports.engine.JasperExportManager'
    JR_EXCEPTION                    = Rjb::import 'net.sf.jasperreports.engine.JRException'
    JASPER_FILL_MANAGER             = Rjb::import 'net.sf.jasperreports.engine.JasperFillManager'
    JASPER_PRINT                    = Rjb::import 'net.sf.jasperreports.engine.JasperPrint'
    JRXML_UTILS                     = Rjb::import 'net.sf.jasperreports.engine.util.JRXmlUtils'
    JR_EMPTY_DATA_SOURCE            = Rjb::import 'net.sf.jasperreports.engine.JREmptyDataSource'
    JR_XPATH_QUERY_EXECUTER_FACTORY = Rjb::import 'net.sf.jasperreports.engine.query.JRXPathQueryExecuterFactory'
    INPUT_SOURCE                    = Rjb::import 'org.xml.sax.InputSource'
    STRING_READER                   = Rjb::import 'java.io.StringReader'
    HASHMAP                         = Rjb::import 'java.util.HashMap'
    BYTE_ARRAY_INPUT_STREAM         = Rjb::import 'java.io.ByteArrayInputStream'
    STRING                          = Rjb::import 'java.lang.String'
    LOCALE                          = Locale = Rjb::import 'java.util.Locale'



    JasperOnRailsPdf.config[:report_params]["XML_LOCALE"]       = LOCALE.new('pt', 'BR')
    JasperOnRailsPdf.config[:report_params]["REPORT_LOCALE"]    = LOCALE.new('pt', 'BR')
    JasperOnRailsPdf.config[:report_params]["XML_DATE_PATTERN"] = 'dd-MM-YY'
    JasperOnRailsPdf.config[:response_options][:disposition]    = 'inline'
    JasperOnRailsPdf.config[:xml_options][:dasherize]           = false
  end

end

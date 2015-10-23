# -*- encoding: utf-8 -*-
module JasperOnRailsPdf
  class PdfGenerator
    attr_reader :jrxml_file, :jasper_file
    attr_reader :resource

    def initialize(jrxml, resource)
      @jrxml_file    = jrxml
      @jasper_file   = jrxml_file.sub(/\.jrxml$/, ".jasper")
      @resource = resource
    end

    def compile
      JASPER_COMPILE_MANAGER.compileReportToFile(jrxml_file, jasper_file)
    end

    def fill
      JASPER_FILL_MANAGER.fillReport(jasper_file, data_document)
    end

    def params
      jasper_params = HASHMAP.new

      JasperOnRailsPdf.config[:report_params].each do |k, v|
        jasper_params.put(k, v)
      end
    end

    def input_source
      options = JasperOnRailsPdf.config[:xml_options]
      INPUT_SOURCE.new.setCharacterStream(STRING_READER
                                      .new(resource.to_xml(options).to_s))
    end

    def data_document
      data_document = silence_warnings do
        JRXML_UTILS._invoke('parse', 'Lorg.xml.sax.InputSource;', input_source)
      end

      jasper_params
        .put(JR_XPATH_QUERY_EXECUTER_FACTORY.PARAMETER_XML_DATA_DOCUMENT,
             data_document)
    end

    def render
      compile
      JASPER_EXPORT_MANAGER._invoke('exportReportToPdf',
                                    'Lnet.sf.jasperreports.engine.JasperPrint;',
                                    fill)
    rescue StandardError => e
      check_stack_trace(e)
      raise e
    end

    private

    def check_stack_trace(e)
      if e.respond_to? 'printStackTrace'
        ::Rails.logger.error e.message
        e.printStackTrace
      else
        ::Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
      end
    end
  end
end

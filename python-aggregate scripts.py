          import xml.etree.ElementTree as ET
          import glob
          import os

          trx_files = glob.glob(os.path.join(os.environ['AGENT_TEMPDIRECTORY'], '*.trx'))
          total, passed, failed, skipped = 0, 0, 0, 0

          for file in trx_files:
              tree = ET.parse(file)
              root = tree.getroot()
              namespaces = {
                  'ns' : 'http://microsoft.com/schemas/VisualStudio/TeamTest/2010',
                  'ns2' : 'http://microsoft.com/schemas/VisualStudio/TeamTest/2020'
              }

              for ns_key, ns_url in namespaces.items():
                results = root.find(f".//{{{ns_url}}}Results")
                if results is not None:
                    total += len(results.findall(f"{{{ns_url}}}UnitTestResult"))
                    passed += len(results.findall(f"{{{ns_url}}}UnitTestResult[@outcome='Passed']"))
                    failed += len(results.findall(f"{{{ns_url}}}UnitTestResult[@outcome='Failed']"))
                    skipped += len(results.findall(f"{{{ns_url}}}UnitTestResult[@outcome='NotExecuted']"))

          print(f"Total Tests: {total}")
          print(f"Passed: {passed}")
          print(f"Failed: {failed}")
          print(f"Skipped: {skipped}")

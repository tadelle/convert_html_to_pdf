from xhtml2pdf import pisa


def convert_html_to_pdf(html_path):
    with open(html_path, "r", encoding='utf-8') as html_file:
        html_string = html_file.read()

    pdf_path = html_path.replace(".html", ".pdf")
    
    with open(pdf_path, "wb") as pdf_file:
        pisa_status = pisa.CreatePDF(html_string, dest=pdf_file)

    if pisa_status.err:
        pdf_path = ''

    return pdf_path

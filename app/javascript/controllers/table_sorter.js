import { Controller } from "@hotwired/stimulus"

//  If the given child is a reference to an existing node in the document, appendChild() 
//  moves it from its current position to the new position (there is no requirement to remove the 
//  node from its parent node before appending it to some other node). 
export default class extends Controller {
  connect() {
    console.log("connected table-sorter")

    const getCellValue = (tr, idx) => tr.children[idx].innerText || tr.children[idx].textContent;

    const comparer = (idx, asc) => (a, b) => ((v1, v2) =>
      v1 !== '' && v2 !== '' && !isNaN(v1) && !isNaN(v2) ? v1 - v2 : v1.toString().localeCompare(v2)
    )(getCellValue(asc ? a : b, idx), getCellValue(asc ? b : a, idx));

    const table = this.element;
    table.querySelectorAll('th').forEach(th => th.addEventListener('click', (() => {
      const thead = this.element.querySelector('tbody');
      Array.from(table.querySelectorAll('tr:nth-child(n+2)'))
           .sort(comparer(Array.from(th.parentNode.children).indexOf(th), this.asc = !this.asc))
           .forEach(tr =>thead.appendChild(tr) );
    })));
  }
}

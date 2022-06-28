import { Component, OnInit } from '@angular/core';
import { MatAccordion } from '@angular/material/expansion';

@Component({
  selector: 'app-about',
  templateUrl: './about.component.html',
  styleUrls: ['./about.component.scss']
})
export class AboutComponent implements OnInit {
  panelOpenState = false;

  constructor() {}

  ngOnInit(): void {}

  collapseAll(accordion: MatAccordion) {
    accordion.closeAll();
  }
}

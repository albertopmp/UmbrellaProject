import { Component, OnInit, ViewChild } from '@angular/core';
import { MatAccordion } from '@angular/material/expansion';

@Component({
  selector: 'app-about',
  templateUrl: './about.component.html',
  styleUrls: ['./about.component.scss']
})
export class AboutComponent implements OnInit {
  @ViewChild('accordion') accordion: MatAccordion;

  constructor() {}

  ngOnInit(): void {}

  collapseAll() {
    this.accordion.closeAll();
  }
}

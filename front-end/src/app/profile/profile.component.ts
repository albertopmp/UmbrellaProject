import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit {
  visibilityMap = new Map<string, boolean>([
    ['cloud', true],
    ['edu', false],
    ['exp', false],
    ['certs', false]
  ]);

  constructor() {}

  ngOnInit(): void {}

  onListItemClick(item: string) {
    this.visibilityMap.forEach((value, key, map) => {
      map.set(key, false);
    });
    this.visibilityMap.set(item, true);
  }
}
